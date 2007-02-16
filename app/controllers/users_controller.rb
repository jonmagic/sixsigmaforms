class UsersController < ApplicationController

  # GET /users
  # GET /users.xml
  def index
    @users = User.find_all_by_doctor_id(Doctor.id_of_alias(params[:doctor_alias]))
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

  # render new.rhtml
  def new
   @user = User.new
   @user.doctor_id = Doctor.id_of_alias(params[:doctor_alias])
  end

  # render show.rhtml
  def show
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # GET /users/register?activation_code=...
  def register
    @user = User.find_by_activation_code(params[:user] ? params[:user][:activation_code] : params[:activation_code])
  end

  def create
    @user = User.new(params[:user])
    @user.doctor_id = Doctor.id_of_alias(params[:doctor_alias])
    @user.save!
#    self.current_user = @user
    redirect_back_or_default(doctor_user_path(params[:doctor_alias]))
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => "new"
  end

  def activate
    if !params[:user] || !params[:user][:activation_code]
      redirect_back_or_default(doctor_user_path(params[:doctor_alias], '/register'))
    else
#Find unregistered user (need to choke if not a valid code)
      @user = User.find_by_activation_code(params[:user][:activation_code])
      if @user.nil?
        flash[:notice] = "Invalid Registration Code!"
        render :action => "register"
      end
#Set the username and password validations active
      @user.changing_login
#Automatically log the user in
#      self.current_user = @user
#Put in appropriate error messages: already activated, etc
#****
#      if logged_in? && !@user.activated?
      if !@user.activated?
        respond_to do |format|
          if @user.update_attributes!(params[:user])
            @user.activate
            flash[:notice] = "Signup complete! #{@user.username} is ready for login."
            format.html { redirect_to doctor_login_path(params[:doctor_alias]) }
            format.xml  { head :ok }
          else
            format.html { render :action => "register" }
            format.xml  { render :xml => @user.errors.to_xml }
          end
        end
      else
# Should this ever happen? Should it be recorded in some master error log?
        flash[:notice] = "An unknown error occurred during activation: #{self.current_user.to_yaml}"
        render :action => "register"
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :action => "register"
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to doctor_user_path(:doctor_alias => params[:doctor_alias]) }
      format.xml  { head :ok }
    end
  end
end
