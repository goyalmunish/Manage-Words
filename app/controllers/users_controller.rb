class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :admin_only, except: [:edit_your_dictionaries, :update_your_dictionaries, :backup_restore_form, :backup_restore]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:words => :flags).all
  end

  def words
    @users = User.includes(:words => :flags).all

    # responding
    if stale?(etag: [@users])
      respond_to do |format|
        # format.html # index.html.erb
        format.xml { render :xml => DataElement.data_backup(@users) }
        format.json { render :json => DataElement.data_backup(@users) }
        format.download { send_data DataElement.data_backup(@users).to_json, {:filename => "words_for_all_users #{Time.now.getutc}.json".split(' ').join('-')} }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_your_dictionaries
    # checking if user is trying to hack
    passed_user_id = params[:id].to_i
    unless passed_user_id == current_user.id
      raise 'TryingToHack'
    end
    # generating instance variable for view
    @user = User.includes(:dictionaries).find(current_user.id)
  end

  def update_your_dictionaries
    # checking if user is trying to hack
    passed_user_id = params[:id].to_i
    unless passed_user_id == current_user.id
      raise 'TryingToHack'
    end
    # updating
    @user = User.includes(:dictionaries).find(current_user.id)
    respond_to do |format|
      if @user.update(dictionary_ids_params)
        format.html { redirect_to flags_path, notice: 'User dictionaries were successfully updated.' }
      else
        format.html { redirect_to flags_path, alert: 'Error in updating your dictionaries' }
      end
    end
  end

  def backup_restore_form
  end

  def backup_restore
    # getting json content
    file = params[:file]
    json_content = JSON.parse(file.read)
    # passing it to model to process
    count = WordDataElement.restore_word_data_backup(:user => current_user, :array_data => json_content)
    # responding to user
    flash[:notice] = "Number of records added: #{count}"
    redirect_to root_path and return
  end

  def backup_restore_for_all_users_form

  end

  def backup_restore_for_all_users
    # getting json content
    file = params[:file]
    json_content = JSON.parse(file.read)
    # passing it to model to process
    count = DataElement.restore_data_backup(json_content)
    # responding to user
    flash[:notice] = "Number of records added: #{count}"
    redirect_to root_path and return
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.includes(:words => :flags).find(params[:id])
  end

  def dictionary_ids_params
    params.require(:user).permit(:dictionary_ids => [])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :provider, :uid, :additional_info)
  end
end
