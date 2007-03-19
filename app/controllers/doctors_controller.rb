class DoctorsController < ApplicationController

#The Doctors controller exists for the Doctor Admins to view and manage their own profile,
# and for Doctor Users to springboard from in their dashboard.
  before_filter :validate_doctor_and_form_type
  in_place_edit_for :doctor, 'friendly_name'
  in_place_edit_for :doctor, 'address'
  in_place_edit_for :doctor, 'telephone'
  in_place_edit_for :doctor, 'contact_person'
  layout 'doctor'

  # GET /:domain/dashboard
  def dashboard
    #To keep someone from getting a page that doesn't map to a real doctor, anonymous will be expelled from this action to the login page, and anyone logged in will be redirected to their respective doctor
#    is_valid_doctor(params[:domain])
  end

#This should be operational for doctor admins to view and edit their account
  def profile
    @doctor = current_doctor
  end

#This needs to be locked down to do only what it should be allowed to do
# An Ajax-only action.
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

end
