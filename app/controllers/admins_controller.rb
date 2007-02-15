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

  # GET /doctors/1
  # GET /doctors/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @admin.to_xml }
    end
  end

  # GET /admins/register?activation_code=...
  def register
    @admin = Admin.find_by_activation_code(params[:admin] ? params[:admin][:activation_code] : params[:activation_code])
  end

  def activate
    if !params[:admin] || !params[:admin][:activation_code]
      redirect_back_or_default(admins_path+'/register')
    else
#Find unregistered user (need to choke if not a valid code)
      @admin = Admin.find_by_activation_code(params[:admin][:activation_code])
#Set the username and password validations active
      @admin.changing_login
#Automatically log the user in
      self.current_user ||= @admin
#Put in appropriate error messages: already activated, etc
#****
      if logged_in? && !@admin.activated?
        respond_to do |format|
          if @admin.update_attributes(params[:admin])
            @admin.activate
            flash[:notice] = "Signup complete! #{@admin.username} is ready for login."
            format.html { redirect_to admin_url(@admin) }
            format.xml  { head :ok }
          else
            format.html { render :file => "admins/register" }
            format.xml  { render :xml => @admin.errors.to_xml }
          end
        end
      else
        render :file => "admins/register"
      end
#      redirect_back_or_default(admin_path(@admin))
    end
  end

  def create
    @admin = Admin.new(params[:admin])
    @admin.save!
    self.current_user = @admin
    redirect_back_or_default(admin_path(self.current_user))
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
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
