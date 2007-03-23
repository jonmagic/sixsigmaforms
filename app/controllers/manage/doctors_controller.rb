class Manage::DoctorsController < ApplicationController
  layout 'admin'

  # GET /doctors
  # GET /doctors.xml
  def index
    @doctors = Doctor.find(:all)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @doctors.to_xml }
    end
  end

# Need to create a search action in case user hits enter on the live_search box, or else disable hard-submit on the form.
  def search(live = false)
    @phrase = (request.raw_post || request.query_string).slice(/[^=]+/)
    if @phrase.blank?
      render :nothing => true
    else
      if @phrase == 'all'
        @results = Doctor.find(:all)
      else
        @sqlphrase = "%" + @phrase.to_s + "%"
        @results = Doctor.find(:all, :conditions => [ "friendly_name LIKE ? OR alias LIKE ? OR telephone LIKE ?", @sqlphrase, @sqlphrase, @sqlphrase])
      end
      @search_entity = @results.length == 1 ? "Doctor" : "Doctors"
      logger.error "#{@results.length} results."
      render(:partial => 'shared/live_search_results') if live
    end
  end

  def live_search
    search(true)
  end

  # GET /doctors/1
  # GET /doctors/1.xml
  def show
    @doctor = Doctor.find_by_id(params[:id])
    @user   = @doctor.admin
    respond_to do |format|
      format.html # show.rhtml
      # format.xml  { render :xml => (:doctor_account => {:doctor => @doctor, :user => @user}).to_xml }
    end
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
    @user   = User.new
  end

  # GET /doctors/1;edit
  def edit
    @doctor = Doctor.find_by_id(params[:id])
    @user   = @doctor.admin
  end

  # POST /doctors
  # POST /doctors.xml
  def create
#This really doesn't go here but there might be a need for it to be set?
#  default_url_options(:host => 'localhost:3000')
    @doctor = Doctor.new(params[:doctor])
    @user   = User.new(params[:user])
    @user.username = @doctor.alias
    @user.doctor_id = 1 #Fake the validation, this will be overwritten as soon as the doctor is created.
    respond_to do |format|
      if @doctor.valid? & @user.valid?
        @doctor.save
        @user.doctor_id = @doctor.id
        @user.save
#        flash[:notice] = "Doctor [#{@doctor.friendly_name} @ #{@doctor.alias} (#{@doctor.id})] was successfully created, with user [#{@user.friendly_name} @ #{@user.username}]."
        format.html { redirect_to doctor_url(@doctor) }
        format.xml  { head :created, :location => doctor_url(@doctor) }
      else
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
#This doesn't update the FormTypes association if all of them are unchecked...?
      if (@doctor.valid? & @user.valid?) &&  @doctor.update_attributes(params[:doctor]) && @user.update_attributes(params[:user])
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
  end

  # DELETE /doctors/1
  # DELETE /doctors/1.xml
  def destroy
#Use the acts_as_deleted plugin!!!
#****
    @doctor = Doctor.find(params[:id])
    @doctor.destroy
    respond_to do |format|
      format.html { redirect_to doctors_url }
      format.xml  { head :ok }
    end
  end

end
