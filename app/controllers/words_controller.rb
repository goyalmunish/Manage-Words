class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy, :ajax_promote_flag]
  helper_method :current_filters_and_orders, :add_to_current_filters_and_orders

  # GET /words
  # GET /words.json
  def index
    @page_title = ['Words']

    sanitize_flag_id

    # conditionally clear_all_filters_and_orders
    if params[:reset]
      clear_all_filters_and_orders
      redirect_to words_path and return
    end
    if params[:format] == 'download'
      clear_all_filters_and_orders
    end

    # Quick test filters 10 random words from given filters
    if params[:quick_test]
      params[:sort_by] = 'random'; params[:sort_by.to_s] = 'random'
      params[:record_limit] = 10; params[:record_limit.to_s] = 10
    end

    # words collection with eager loaded flags, this collection can be modified going forward
    @words = current_user.words.includes(:flags)
    # user dictionaries
    @dictionaries = current_user.dictionaries

    # checking filters
    if params[:flag_id]
      if params[:flag_id].kind_of? Array
        flag_ids = params[:flag_id].map{|id| id.to_i}.sort
        # flag_ids = Flag.find(params[:flag_id]).pluck(:id)
        relevant_word_ids = []
        flag_ids.map do |flag_id|
          relevant_word_ids << @words.with_flag_id(flag_id).pluck(:id)
        end
        @words = @words.where(:id => relevant_word_ids)
      else
        if params[:flag_id].to_i > 0
          @flag = Flag.find(params[:flag_id])
          @temp_words = @words.with_flag_id(@flag.id)
        elsif params[:flag_id].to_i == 0
          @temp_words = @words.without_flag
        end
        relevant_word_ids = @temp_words.pluck(:id)
        @words = @words.where(:id => relevant_word_ids)
      end
    end
    if params[:filter_by]
      if params[:filter_by] == 'without_trick'
        @words = @words.without_trick
      elsif params[:filter_by] == 'with_trick'
        @words = @words.with_trick
      end
    end
    if params[:search_text]
      if params[:search_negative] == '1'
        search_negative = true
      else
        search_negative = false
      end
      @words = @words.search(database: AppSetting.get('database'), search_text: params[:search_text], search_type: params[:search_type], search_negative: search_negative)
    end

    # checking orders
    if params[:sort_by]
      if params[:sort_by] == 'random'
        @words = @words.sort_by { rand }  # Note that @words is an Array now
      elsif params[:sort_by] == 'recent'
        @words = @words.reorder(:updated_at => :desc)
      elsif params[:sort_by] == 'id'
        @words = @words.reorder(:id => :asc)
      end
    end

    # limiting records
    @words = Word.limit_records(:record_limit => params[:record_limit], :collection => @words)

    # generating additions required instance variables
    @flag_size = Word.number_of_flag_associations(@words)

    # generating custom ETag
    # fresh_when([@words, @filters, @order])

    # responding
    current_etag = [current_user.id, current_filters_and_orders, @words]
    if ENV['RAILS_ENV'] == 'development'
      current_etag << Time.now  # adding time as parameter to disable etags in development mode
    end
    if params[:sort_by] == 'random'
      current_etag = Time.now # skipping caching in case of random sort
    end
    if stale?(etag: current_etag)
      respond_to do |format|
        format.html # index.html.erb
        format.json # index.json.jbuilder
        format.xml { render :xml => @words.to_xml(:include => {:flags => {:only => [:name, :value]}}, :only => [:word, :trick, :additional_info]) }
        format.download { send_data JSON.pretty_generate(WordDataElement.word_data_backup(@words)), {:filename => "words #{Time.now.getutc}.json".split(' ').join('-')} }
      end
    end

  end

  # this action is no longer used as now cache is being expired on 'touch' on association
  # def expire_my_word_caches
  #   Word.touch_latest_updated_at_word_record_for_user(current_user)
  #   redirect_to words_path and return
  # end

  # GET /words/1
  # GET /words/1.json
  def show
    @page_title = [@word.word]
    @dictionaries = current_user.dictionaries
  end

  # GET /words/new
  def new
    @word = current_user.words.build
  end

  # GET /words/1/edit
  def edit
    @page_title = [@word.word, 'Edit']
  end

  # POST /words
  # POST /words.json
  def create
    @word = current_user.words.build(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_statistics
    require 'rinruby'

    words = current_user.words
    @words_hash = Hash.new
    all_characters = ('a'..'z').to_a
    all_characters.each do |char|
      temp_words = words.search(database: AppSetting.get('database'), search_text: "^#{char}", search_type: 'word', search_negative: false)
      temp_words_count = temp_words.count
      @words_hash[char.to_s] = temp_words_count
    end
    R.eval %Q{
      freq <- vector(mode='integer', length = 26)
      names(freq) <- letters
    }
    @words_hash.each do |key, value|
      R.eval %Q{freq["#{key}"] <- as.numeric("#{value}")}
      end
    R.eval %Q{
      png(filename="public/images/graphs/word_statistics_for_id_#{current_user.id}.png")
      barplot(freq, ylim=c(0,200), main='Words Distribution', xlab='Words starting with character', ylab='Frequency', width=2, cex.axis=1.2, col = heat.colors(12))
      dev.off()}
  end

  def ajax_promote_flag
    @word.promote_flag(:flag_name => params[:flag_name], :dir => params[:dir])
    respond_to do |format|
      format.html {redirect_to @word}
      format.json {render :json => @word.flags}
      format.js {}
    end
  end

  # note that this method should not attempt to add values to params directly
  def add_to_current_filters_and_orders(passed_hash = nil)
    filters_and_orders = current_filters_and_orders
    # adding passed hash to params
    unless passed_hash.blank?
      passed_hash.each do |key, value|
        filters_and_orders[key] = value
      end
    end
    # returning current value of filters and orders
    return filters_and_orders
  end

  # helper method
  def current_filters_and_orders
    sanitize_flag_id
    filters_and_orders = Hash.new
    # existing filters or orders
    [:flag_id, :sort_by, :filter_by, :search_text, :search_type, :search_negative, :record_limit].each do |elem|
      if params[elem]
        filters_and_orders[elem] = params[elem]
      end
    end
    return filters_and_orders
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = current_user.words.includes(:flags).friendly.find(params[:id])
  end

  def sanitize_flag_id
    # case when flag_id contains multiple ids as string
    if params[:flag_id] && params[:flag_id].split.size > 1
      params[:flag_id] = params[:flag_id].split
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
    # patch for check_box_tag
    # an attribute from check_box_tag becomes part of params only if it is checked
    # so, the if you try to uncheck the only unchecked flag left for a word, nothing happen to flags association
    # it is because flag_ids in this case is nil, so we need to set it to blank array
    # also note that this patch is not required for collection_check_box
    # unless params[:word][:flag_ids]
    #   params[:word][:flag_ids] = []
    # end
    # resuming to actual logic

    if params[:data]
      # TODO: Remove code smell by finding a better way (such as using https://github.com/cerebris/jsonapi-resources)
      # Note: This is just a make-ship arrangment

      id = params[:data][:id].to_i
      attributes = params[:data][:attributes]
      relationships = params[:data][:relationships][:flags][:data]
      flag_ids = []
      relationships.each do |hsh|
        flag_ids << hsh[:id].to_i
      end
      wd_params = ActiveSupport::HashWithIndifferentAccess.new(
        :id => id,
        :flag_ids => flag_ids
      ).merge!(attributes)

      # Rename created-at, updated-at, and additional-info
      ["created-at".to_sym, "updated-at".to_sym, "additional-info".to_sym].each do |ember_key|
        ruby_key = ember_key.to_s.split("-").join("_").to_sym
        wd_params[ruby_key] = wd_params[ember_key]
        wd_params.delete(ember_key)
      end

      # Remove :created_at and :updated_at fields
      [:created_at, :updated_at].each do |ruby_key|
        wd_params.delete(ruby_key)
      end

      wd_params
    else
      params.require(:word).permit(:word, :trick, :additional_info, :flag_ids => [])
    end
  end

  # called by index action
  def clear_all_filters_and_orders
    [:flag_id, :sort_by, :filter_by, :reset].each do |elem|
      params[elem] = nil
      # session[elem] = nil # though, this is not required
    end
  end

end

