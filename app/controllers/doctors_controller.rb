class DoctorsController < ApplicationController
  # GET /doctors
  # GET /doctors.xml
  def index
    @doctors = Doctor.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @doctors.to_xml }
    end
  end

  # GET /doctors/1
  # GET /doctors/1.xml
  def show
    @doctor = Doctor.find(params[:id])
    @user   = @doctor.admin

    respond_to do |format|
      format.html # show.rhtml
#      format.xml  { render :xml => (:doc => {:doctor => @doctor, :user => @user}).to_xml }
    end
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
    @user   = User.new
  end

  # GET /doctors/1;edit
  def edit
    @doctor = Doctor.find(params[:id])
    @user =   @doctor.admin
  end

  # POST /doctors
  # POST /doctors.xml
  def create
    @doctor = Doctor.new(params[:doctor])
    @user   = User.new(params[:user])
    @user.username = @doctor.alias
    @user.doctor_id = 1 #Fake the validation, this will be overwritten as soon as the doctor is created.
    respond_to do |format|
      if @doctor.valid? and @user.valid?
        @doctor.save
        @user.doctor_id = @doctor.id
        @user.save
#        flash[:notice] = "Doctor [#{@doctor.friendly_name} @ #{@doctor.alias} (#{@doctor.id})] was successfully created, with user [#{@user.friendly_name} @ #{@user.username}]."
        format.html { redirect_to doctor_url(@doctor) }
        format.xml  { head :created, :location => doctor_url(@doctor) }
      else
        @user.valid?
        format.html { render :action => "new" }
        format.xml  { render :xml => @doctor.errors.to_xml }
      end
    end
  end

#This needs to be locked down to do only what it should be allowed to do
  # PUT /doctors/1
  # PUT /doctors/1.xml
  def update
    @doctor = Doctor.find(params[:id])
    @user   = @doctor.admin

    respond_to do |format|
      if @doctor.update_attributes(params[:doctor])
        flash[:notice] = "Doctor was successfully updated."
        format.html { redirect_to doctor_url(@doctor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @doctor.errors.to_xml }
      end
    end
  end

  # GET /:doctor_alias/dashboard
  def dashboard
    #To keep someone from getting a page that doesn't map to a real doctor, anonymous will be expelled from this action to the login page, and anyone logged in will be redirected to their respective doctor
    if logged_in?
      if !(current_user.doctor.alias == params[:doctor_alias])
        redirect_back_or_default(doctor_dashboard_path(current_user.doctor.alias))
      end
    else
      if Doctor.exists?(params[:doctor_alias])
        redirect_back_or_default(doctor_login_path(params[:doctor_alias]))
      else
        redirect_back_or_default('/')
      end
    end
  end

  # DELETE /doctors/1
  # DELETE /doctors/1.xml
  def destroy

#Must also destroy the admin user and all other users tied with this business. But then what exactly do we want to do with destroying doctors? Do we ever want to destroy them?
#****
    @doctor = Doctor.find(params[:id])
    @doctor.destroy

    respond_to do |format|
      format.html { redirect_to doctors_url }
      format.xml  { head :ok }
    end
  end
end
