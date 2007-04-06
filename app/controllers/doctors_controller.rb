class DoctorsController < ApplicationController
  before_filter :current_user

  in_place_edit_for :doctor, 'friendly_name'
  in_place_edit_for :doctor, 'address'
  in_place_edit_for :doctor, 'telephone'
  in_place_edit_for :doctor, 'contact_person'
  layout 'doctor'

# AccessControl:
#  dashboard: anyone logged in to the current accessed_doctor
#  profile:   only the current accessed_doctor's doctor admin
#  update:    only the current accessed_doctor's doctor admin

  # GET /:domain/dashboard
  def dashboard
    restrict('allow only doctor users')
  end

#This should be operational for doctor admins to view and edit their account
  def profile
    restrict('allow only doctor admins') or begin
      @doctor = current_doctor
    end
  end

#This needs to be locked down to do only what it should be allowed to do
# An Ajax-only action.
  def update
    restrict('allow only doctor admins') or begin
      @doctor = Doctor.find(params[:id])
      log = Log.new(:log_type => 'update:Doctor', :data => {:old_attributes => @doctor.attributes.changed_values(params[:doctor])}, :object => @doctor, :agent => current_user)
logger.error "Created log: #{log}\n"
      respond_to do |format|
  #This doesn't update the FormTypes association if all of them are unchecked...?
  logger.error "Current user #{@current_user}...\n"
        if (@doctor.valid?) &&  @doctor.update_attributes(params[:doctor])
          logger.error "Current user #{@current_user}...\n"
          log.save
          flash[:notice] = "Doctor was successfully updated."
          format.html { redirect_to doctor_url(@doctor) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @doctor.errors.to_xml }
        end
      end
    end
  end

end
