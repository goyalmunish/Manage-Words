class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    @filters = Array.new
    @order = String.new
    # resetting parameters
    if params[:reset] || params[:format] == 'download'
      [:flag_id, :sort_by, :filter_by, :reset].each do |elem|
        params[elem] = nil
        session[elem] = nil
      end
    end

    # setting params hash to session
    [:flag_id, :sort_by, :filter_by].each do |elem|
      if params[elem]
        session[elem] = params[elem]
      end
    end

    # checking filters
    if session[:flag_id]
      if session[:flag_id].to_i > 0
        @flag = Flag.find(session[:flag_id])
        @words = current_user.words.with_flag_having_id(@flag.id)
        @filters << "Flag: #{"#{@flag.name}-#{@flag.value}"}"
      elsif session[:flag_id].to_i == 0
        @words = current_user.words.without_flag
        @filters << "Flag: #{"No Flag"}"
      end
    else
      @words = current_user.words.includes(:flags)
    end
    if session[:filter_by]
      if session[:filter_by] == 'without_trick'
        @words = @words.without_trick
        @filters << 'Without Trick'
      elsif session[:filter_by] == 'with_trick'
        @words = @words.where("trick IS NOT NULL")
        @filters << 'With Trick'
      end
    end
    # checking order
    if session[:sort_by]
      if session[:sort_by] == 'random'
        @words = @words.sort_by{rand}
        @order = 'Random'
      elsif session[:sort_by] == 'recent'
        @words = @words.reorder(:updated_at => :desc)
        @order = 'Recent'
      end
    end

    # responding
    respond_to do |format|
      format.html # index.html.erb
      format.json # index.json.jbuilder
      format.xml { render :xml => @words.to_xml(:include => {:flags => {:only => [:name, :value]}}, :only => [:word, :trick, :additional_info]) }
      format.download { send_data Word.data_backup(@words).to_json, {:filename => "words #{Time.now.getutc}.json".split(' ').join('-')} }
    end
  end

  def expire_caches
    Word.touch_latest_updated_at_record
    redirect_to words_path and return
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = current_user.words.build
  end

  # GET /words/1/edit
  def edit
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
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def backup_restore_form
  end

  def backup_restore
    # getting json content
    file = params[:file]
    json_content = JSON.parse(file.read)
    # passing it to model to process
    count = Word.restore_backup(current_user.id, json_content)
    # responding to user
    flash[:notice] = "Number of records added: #{count}"
    redirect_to words_path and return
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = current_user.words.includes(:flags).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
    # patch for check_box_tag
    # an attribute from check_box_tag becomes part of params only if it is checked
    # so, the if you try to uncheck the only unchecked flag left for a word, nothing happen to flags association
    # it is because flag_ids in this case is nil, so we need to set it to blank array
    unless params[:word][:flag_ids]
      params[:word][:flag_ids] = []
    end
    # resuming to actual logic
    params.require(:word).permit(:word, :trick, :additional_info, :flag_ids => [])
  end
end
