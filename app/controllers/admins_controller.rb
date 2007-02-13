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

  def create
    @admin = Admin.new(params[:admin])
    @admin.save!
    self.current_user = @admin
    redirect_back_or_default(admin_path(self.current_user))
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def activate
    self.current_user = Admin.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.activated?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default(admin_path(self.current_user))
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
