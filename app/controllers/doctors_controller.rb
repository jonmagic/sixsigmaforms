class DoctorsController < ApplicationController

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

end
