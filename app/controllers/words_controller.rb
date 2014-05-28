class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    if params[:flag_id]
      @flag = Flag.find(params[:flag_id])
      @words = current_user.words.includes(:flags).where("flags.id" => @flag.id)
    else
      @words = current_user.words.includes(:flags)
    end
    if params[:without_trick]
      @words = @words.without_trick
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json # index.json.jbuilder
      format.xml { render :xml => @words.to_xml(:include => {:flags => {:only => [:name, :value]}}, :only => [:word, :trick, :additional_info]) }
      format.download { send_data Word.data_for_backup_and_restore(@words).to_json, {:filename => "words #{Time.now.getutc}.json".split(' ').join('-')} }
    end
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = current_user.words.includes(:flags).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
    params.require(:word).permit(:word, :trick, :additional_info, :flag_ids => [])
  end
end
