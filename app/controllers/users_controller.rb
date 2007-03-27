class UsersController < ApplicationController
  in_place_edit_for :user, 'friendly_name'
  in_place_edit_for :user, 'email'
  layout 'doctor'

  # render show.rhtml
  def show
    restrict('allow only doctor users') or begin
      @user = get_user
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @user.to_xml }
      end
    end
  end

  # GET /admins/register?activation_code=...
  def register
    if !given_activation_code.blank?
      @user = User.find_by_activation_code(given_activation_code)
      if !@user.blank?
        current_user = @user
      else
        flash[:notice] = "Invalid activation code!"
        render "users/register_activation"
      end
    else
      flash[:notice] = "You must have an activation code to continue!"
      render "users/register_activation"
    end
  end

  def activate
    if !given_activation_code.blank?
      #Find unregistered user (need to choke if not a valid code)
      @user = User.find_by_activation_code(given_activation_code)
      if !@user.blank?
        current_user = @user
        @user.operation = 'activate'
        if !@user.activated?
          respond_to do |format|
            if @user.update_attributes(params[:user])
              #Log the user in
              self.current_user = @user
              flash[:notice] = "Signup complete! #{@user.username} is ready for login."
              format.html { redirect_to user_account_url }
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
      redirect_back_or_default(user_path(:action => 'register'))
    end
  end

#This needs to be locked down to do only what it should be allowed to do
  def update
    restrict('allow only doctor users') or begin
      @user = get_user
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to user_url(@user) }
          format.js
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.js
          format.xml  { render :xml => @user.errors.to_xml }
        end
      end
    end
  end

  # GET /users
  # GET /users.xml
  def index
    restrict('allow only doctor admins') or begin
      return access_denied unless current_user.is_doctor_or_admin?
      @users = User.find_all_by_doctor_id(Doctor.id_of_alias(params[:domain]))
      respond_to do |format|
        format.html # index.rhtml
        format.js
        format.xml  { render :xml => @users.to_xml }
      end
    end
  end

  # render new.rhtml
  def new
    restrict('allow only doctor admins') or begin
      @user = User.new
      @user.doctor_id = Doctor.id_of_alias(params[:domain])
    end
  end

# Need to create a search action in case user hits enter on the live_search box, or else disable hard-submit on the form.

  def live_search
    restrict('allow only doctor admins') or begin
      @phrase = (request.raw_post || request.query_string).slice(/[^=]+/)
      if @phrase.blank?
        render :nothing => true
      else
        @sqlphrase = "%" + @phrase.to_s + "%"
        @results = User.find(:all, :conditions => [ "friendly_name LIKE ? OR username LIKE ?", @sqlphrase, @sqlphrase])
        @search_entity = @results.length == 1 ? "User" : "Users"
        render(:partial => 'shared/live_search_results')
      end
    end
  end

  def create
    restrict('allow only doctor admins') or begin
      @user = User.new
      @user.friendly_name = params[:user][:friendly_name]
      @user.email = params[:user][:email]
      @user.doctor = Doctor.find_by_alias(params[:domain])
      if @user.save
        redirect_back_or_default(users_path)
        flash[:notice] = "User #{@user.friendly_name} has been created."
      else
        render :action => "new"
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
# THIS NEEDS TO USE THE ACTS_AS_DELETED PLUGIN!!
    restrict('allow only doctor admins') or begin
      @user = User.find_by_id(params[:id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to user_path() }
        format.xml  { head :ok }
      end
    end
  end

  private
    def get_user
      current_user.is_doctor_or_admin? ? User.find_by_id(params[:id]) || current_user : current_user
    end
end
