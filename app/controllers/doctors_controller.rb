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

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @doctor.to_xml }
    end
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  # GET /doctors/1;edit
  def edit
    @doctor = Doctor.find(params[:id])
  end

  # POST /doctors
  # POST /doctors.xml
  def create
    @doctor = Doctor.new(params[:doctor])

    respond_to do |format|
      if @doctor.save
        flash[:notice] = "Doctor was successfully created.<br /> <a href='"+doctor_url+";activate?activation_code="+@doctor.activation_code+"'>Activate</a>."
        format.html { redirect_to doctor_url(@doctor) }
        format.xml  { head :created, :location => doctor_url(@doctor) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @doctor.errors.to_xml }
      end
    end
  end

  # PUT /doctors/1
  # PUT /doctors/1.xml
  def update
    @doctor = Doctor.find(params[:id])

    respond_to do |format|
      if @doctor.update_attributes(params[:doctor])
        flash[:notice] = 'Doctor was successfully updated.'
        format.html { redirect_to doctor_url(@doctor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @doctor.errors.to_xml }
      end
    end
  end

  # DELETE /doctors/1
  # DELETE /doctors/1.xml
  def destroy
    @doctor = Doctor.find(params[:id])
    @doctor.destroy

    respond_to do |format|
      format.html { redirect_to doctors_url }
      format.xml  { head :ok }
    end
  end

#Should I separate this to "register" and "activate" ?
# Somehow need to get the model validation working for the registration/activation form.

  # GET /doctors;activate
  # GET /doctors;activate?activation_code=...
  # POST /doctors;activate
  def activate
    if !params[:activation_code].blank? || (!params[:doctor].blank? && !params[:doctor][:activation_code].blank?)
      current_doctor = Doctor.find_by_activation_code(params[:activation_code] || params[:doctor][:activation_code])
      if current_doctor.blank?
        flash[:notice] = "Invalid User Registration Key!"
        render 'doctors/register_code'
      else
        if !current_doctor.activated?
          if !params[:doctor].blank? && !params[:doctor][:username].blank?
            current_doctor.activate_me
            flash[:notice] = "Registration Successful"
            redirect_back_or_default('/')
          else
#            if (!params[:doctor].blank? && !params[:doctor][:activation_code].blank?)
#              flash[:notice] = "Please enter"
#            end
            render 'doctors/register'
          end
        else
          flash[:notice] = "Already Registered"
          redirect_back_or_default('/')
        end
      end
    else
      render 'doctors/register_code'
    end
  end

end
