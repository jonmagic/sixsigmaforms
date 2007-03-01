class UsersController < ApplicationController
  before_filter :require_login_except_register_and_activate
  before_filter :require_doctor_or_admin_for_certain_actions

  # render show.rhtml
  def show
    @user = get_user
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
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
              format.html { redirect_to user_url(:domain => params[:domain], :id => @user) }
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
      redirect_back_or_default(doctor_user_path(:domain => params[:domain], :action => 'register'))
    end
  end

#This needs to be locked down to do only what it should be allowed to do
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = get_user
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

  # GET /users
  # GET /users.xml
  def index
    return access_denied unless current_user.is_doctor_or_admin?
    @users = User.find_all_by_doctor_id(Doctor.id_of_alias(params[:domain]))
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

  # render new.rhtml
  def new
   return access_denied unless current_user.is_doctor_or_admin?
   @user = User.new
   @user.doctor_id = Doctor.id_of_alias(params[:domain])
  end

# Need to create a search action in case user hits enter on the live_search box, or else disable hard-submit on the form.

  def live_search
    return access_denied unless current_user.is_doctor_or_admin?
    @phrase = (request.raw_post || request.query_string).slice(/[^=]+/)
    if @phrase.blank?
      render :nothing => true
    else
      @sqlphrase = "%" + @phrase.to_s + "%"
      @results = User.find(:all, :conditions => [ "friendly_name LIKE ? OR username LIKE ?", @sqlphrase, @sqlphrase])
      @search_entity = @results.length == 1 ? "User" : "Users"
      render(:file => 'shared/live_search_results', :use_full_path => true)
    end
  end

  def create
    return access_denied unless current_user.is_doctor_or_admin?
    @user = User.new
    @user.friendly_name = params[:user][:friendly_name]
    @user.email = params[:user][:email]
    @user.doctor_id = Doctor.id_of_alias(params[:domain])
    if @user.save
      redirect_back_or_default(users_path)
      flash[:notice] = "User #{@user.friendly_name} has been created."
    else
      render :action => "new"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    return access_denied unless current_user.is_doctor_or_admin?
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to doctor_user_path(:domain => params[:domain]) }
      format.xml  { head :ok }
    end
  end

  private
    def get_user
      if current_user.is_doctor_or_admin?
        user = User.find(params[:id])
        return user
      else
        return current_user
      end
    end
    
    def require_login_except_register_and_activate
      return if logged_in? or params[:action] == 'register' or params[:action] == 'activate'
      store_location
      redirect_to login_url(params[:domain])
    end
    
    def require_doctor_or_admin_for_certain_actions
      access_denied if !current_user.is_doctor_or_admin? and (['destroy', 'create', 'live_search', 'search', 'new', 'index'].include?(params[:action]))
    end
end
