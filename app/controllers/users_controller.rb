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

  def create
    @user = User.new
    @user.friendly_name = params[:user][:friendly_name]
    @user.email = params[:user][:email]
    @user.doctor_id = Doctor.id_of_alias(params[:doctor_alias])
    if @user.save
      redirect_back_or_default(users_path)
      flash[:notice] = "User #{@user.friendly_name} has been created."
    else
      render :action => "new"
    end
  end

  # GET /admins/register?activation_code=...
  def register
    act_code = params[:user] ? params[:user][:activation_code] || params[:activation_code] : params[:activation_code]
    if !act_code.blank?
      @user = User.find_by_activation_code(act_code)
      if @user.blank?
        flash[:notice] = "Invalid activation code!"
        render "users/register_activation"
      end
    else
      flash[:notice] = "You must have an activation code to continue!"
      render "users/register_activation"
    end
  end

  def activate
    act_code = params[:user] ? params[:user][:activation_code] || params[:activation_code] : params[:activation_code]
    if !act_code.blank?
      #Find unregistered user (need to choke if not a valid code)
      @user = User.find_by_activation_code(act_code)
      if !@user.blank?
        @user.operation = 'activate'
        if !@user.activated?
          respond_to do |format|
            if @user.update_attributes(params[:user])
              #Log the user in
              self.current_user = @user
              flash[:notice] = "Signup complete! #{@user.username} is ready for login."
              format.html { redirect_to user_url(:doctor_alias => params[:doctor_alias], :id => @user) }
              format.xml  { head :ok }
            else
              format.html { render :action => "register" }
              format.xml  { render :xml => @user.errors.to_xml }
            end
          end
        else
          flash[:notice] = "#{@user.username} is already registered and activated."
          render :action => "register"
        end
      else
        flash[:notice] = "Invalid activation code!"
        render "users/register_activation"
      end
    else
      redirect_back_or_default(doctor_user_path(:doctor_alias => params[:doctor_alias], :action => 'register'))
    end
  end

#This needs to be locked down to do only what it should be allowed to do
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User was successfully updated."
        format.html { redirect_to user_url(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # render show.rhtml
  def show
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
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
