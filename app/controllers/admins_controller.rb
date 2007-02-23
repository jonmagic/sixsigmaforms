class AdminsController < ApplicationController

  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.find(:all)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @admins.to_xml }
    end
  end

  # render new.rhtml
  def new
  end

  def create
    @admin = Admin.new
    @admin.friendly_name = params[:admin][:friendly_name]
    @admin.email = params[:admin][:email]
    if @admin.save
      self.current_user = @admin
      redirect_back_or_default(admin_path(self.current_user))
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  # GET /admins/register?activation_code=...
  def register
    act_code = params[:admin] ? params[:admin][:activation_code] || params[:activation_code] : params[:activation_code]
    if !act_code.blank?
      @admin = Admin.find_by_activation_code(act_code)
      if @admin.blank?
        flash[:notice] = "Invalid activation code!"
        render "admins/register_activation"
      end
    else
      flash[:notice] = "You must have an activation code to continue!"
      render "admins/register_activation"
    end
  end

  def activate
    act_code = params[:admin] ? params[:admin][:activation_code] || params[:activation_code] : params[:activation_code]
    if !act_code.blank?
      @admin = Admin.find_by_activation_code(act_code)
      if !@admin.blank?
        @admin.operation = 'activate'
        if !@admin.activated?
          respond_to do |format|
            if @admin.update_attributes(params[:admin])
              #Log the user in
              self.current_user = @admin
              flash[:notice] = "Signup complete! #{@admin.username} is ready for login."
              format.html { redirect_to admin_url(@admin) }
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
        render "admins/register_activation"
      end
    else
      redirect_back_or_default(admins_path+'/register')
    end
  end

  # GET /doctors/1
  # GET /doctors/1.xml
  def show
    @admin = Admin.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @admin.to_xml }
    end
  end

  # GET /SixSigma/dashboard
  def dashboard
    #To keep someone from getting a page that doesn't map to a real doctor, anonymous will be expelled from this action to the login page, and anyone logged in will be redirected to their respective doctor
    
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to admins_url }
      format.xml  { head :ok }
    end
  end
end
