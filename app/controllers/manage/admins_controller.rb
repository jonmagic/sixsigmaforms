class Manage::AdminsController < ApplicationController
  in_place_edit_for :admin, 'friendly_name'
  in_place_edit_for :admin, 'email'
  layout 'admin'

  # GET /admins
  # GET /admins.xml
  def index
    restrict 'allow only admins' or begin
      @admins = Admin.find(:all)
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @admins.to_xml }
      end
    end
  end

  # render new.rhtml
  def new
    restrict 'allow only admins'
  end

  def create
    restrict 'allow only admins' or begin
      @admin = Admin.new
      @admin.friendly_name = params[:admin][:friendly_name]
      @admin.email = params[:admin][:email]
      if @admin.save
  #      self.current_user = @admin
        redirect_back_or_default(admin_path(@admin))
        flash[:notice] = "Thanks for signing up!"
      else
        render :action => 'new'
      end
    end
  end

  # GET /admins/register?activation_code=...
  def register
    if !given_activation_code.blank?
      @admin = Admin.find_by_activation_code(given_activation_code)
      if @admin.blank?
        flash[:notice] = "Invalid activation code!"
        render "manage/admins/register_activation"
      end
    else
      flash[:notice] = "You must have an activation code to continue!"
      render "manage/admins/register_activation"
    end
  end

  def activate
    if !given_activation_code.blank?
      @admin = Admin.find_by_activation_code(given_activation_code)
# logger.error "Activating? #{@admin.friendly_name}, #{@admin}"
      if !@admin.blank?
        @admin.operation = 'activate'
        if !@admin.activated?
          respond_to do |format|
            if @admin.update_attributes(params[:admin])
              #Log the user in
              self.current_user = logged_in? ? self.current_user : @admin
              flash[:notice] = "Signup complete! #{@admin.username} is ready for login."
              format.html { redirect_to @admin == self.current_user ? user_account_url : admin_url(@admin) }
              format.xml  { head :ok }
            else
              format.html { render :action => "register" }
              format.xml  { render :xml => @admin.errors.to_xml }
            end
          end
        else
          flash[:notice] = "#{@admin.username} is already registered and activated."
          render :action => "register"
        end
      else
        flash[:notice] = "Invalid activation code!"
        render "manage/admins/register_activation"
      end
    else
# logger.error "Couldn't find Activation Code!"
      redirect_to user_account_url(:action => 'register')
    end
  end

  # GET /doctors/1
  # GET /doctors/1.xml
  def show
    restrict 'allow only admins' or begin
      @admin = Admin.find_by_id(params[:id]) || current_user
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @admin.to_xml }
      end
    end
  end

  # GET /SixSigma/dashboard
  def dashboard
    #To keep someone from getting a page that doesn't map to a real doctor, anonymous will be expelled from this action to the login page, and anyone logged in will be redirected to their respective doctor
    restrict 'allow only admins'
  end

  def update
    restrict('allow only admins') or begin
      @admin = Admin.find_by_id(params[:id])
      respond_to do |format|
        if @user.update_attributes(params[:admin])
          format.html { redirect_to admin_url(@admin) }
          format.js
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.js
          format.xml  { render :xml => @admin.errors.to_xml }
        end
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    restrict 'allow only admins' or begin
      @admin = Admin.find_by_id(params[:id])
      @admin.destroy
      respond_to do |format|
        format.html { redirect_to admins_url }
        format.xml  { head :ok }
      end
    end
  end

end
