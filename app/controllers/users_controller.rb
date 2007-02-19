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

  def create
    @user = User.new(params[:user])
    @user.doctor_id = Doctor.id_of_alias(params[:doctor_alias])
    if @user.save
      redirect_back_or_default(doctor_user_path(params[:doctor_alias]))
      flash[:notice] = "User @user.friendly_name has been created."
    else
      render :action => "new"
    end
  end

  # GET /admins/register?activation_code=...
  def register
    activation_code = params[:user] ? params[:user][:activation_code] || params[:activation_code] : params[:activation_code]
    if activation_code
      @user = User.find_by_activation_code(activation_code)
      if !@user
        flash[:notice] = "Invalid activation code!"
        render "users/register_activation"
      end
    else
      flash[:notice] = "You must have an activation code to continue!"
      render "users/register_activation"
    end
  end

  def activate
    activation_code = params[:user] ? params[:user][:activation_code] || params[:activation_code] : params[:activation_code]
    if activation_code
      #Find unregistered user (need to choke if not a valid code)
      @user = User.find_by_activation_code(activation_code)
      if @user
        #Set the username and password validations active
        @user.changing_login
        #Automatically log the user in
#        self.current_user = @user
        if !@user.activated?
          respond_to do |format|
            if @user.update_attributes!(params[:user])
              @user.activate
              flash[:notice] = "Signup complete! #{@user.username} is ready for login."
              format.html { redirect_to user_url(@user) }
              format.xml  { head :ok }
            else
              flash[:notice] = "Invalid record!"
              format.html { render :action => "register" }
              format.xml  { render :xml => @user.errors.to_xml }
            end
          end
        else
          flash[:notice] = "#{@user.username} is already registered and activated."
          render :action => "register"
        end
      else
        #No user with that activation code
        flash[:notice] = "Invalid activation code!"
        render :action => "register"
#        render "users/register_activation"
      end
    else
      #No activation code present
      redirect_back_or_default(users_path+'/register')
    end
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
