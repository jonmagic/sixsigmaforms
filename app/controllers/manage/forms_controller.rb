class Manage::FormsController < ApplicationController
  layout 'admin'
#This is the Admins' controller for manipulating forms. It isn't very completed yet.

  #GET /forms/:status
  def index
    restrict('allow only admins') or begin
      if params[:form_status].nil?
        redirect_to admin_forms_by_status_path(:form_status => 'submitted')
      elsif params[:form_status] == 'archived'
        render :action => 'archive_view'
      else
        @forms = FormInstance.find_all_by_status_number(params[:form_status].as_status.number)
      end
    end
  end

  def view
    restrict('allow only admins') or begin
      @form_instance = FormInstance.find_by_form_data_type_and_form_data_id(params[:form_type], params[:form_id])
      @form = @form_instance.form_data
logger.error "Status: #{@form_instance.status} // #{params[:form_status]}=#{params[:form_status].as_status.number}\n"
      if @form_instance.status.as_status.number < params[:form_status].as_status.number and (params[:form_status].as_status.number == 3 or params[:form_status].as_status.number == 4)
        @form_instance.status = params[:form_status]
        @form_instance.save
      end
    end
  end

  def archive_view
  end

#There should be three fields here: Doctor, Patient, Date
  def search(live=false)
    doctor  = nil
    user    = nil
    patient = nil
    date    = nil

    doctor  = "%" + params[:doctor_field]  + "%" if !params[:doctor_field].nil? and params[:doctor_field].length > 0
    user    = "%" + params[:user_field]    + "%" if !params[:user_field].nil? and params[:user_field].length > 0
    patient = "%" + params[:patient_field] + "%" if !params[:patient_field].nil? and params[:patient_field].length > 0
#Learn how to handle Dates in rails' forms
    # date    = params[:date_field].nil? ? Date.new. : params[:date_field]

logger.error "D: #{doctor}/#{params[:doctor_field]}; U: #{user}/#{params[:user_field]}; P: #{patient}/#{params[:patient_field]}\n"

    tables = ['form_instances']
    tables.push('doctors') unless doctor.nil?
    tables.push('users') unless user.nil?
    tables.push('patients') unless patient.nil?

    #Put the date field in first by default - there will always be a date to search for.
    matches = ['form_instances.status_number=4'] #Make sure there's always at least one requirement here for the WHERE clause!
    matches.push('form_instances.doctor_id=doctors.id') unless doctor.nil?
    matches.push('form_instances.user_id=users.id') unless user.nil?
    matches.push('form_instances.patient_id=patients.id') unless patient.nil?
    matches.push('doctors.friendly_name LIKE :doctor') unless doctor.nil?
    matches.push('users.friendly_name LIKE :user') unless user.nil?
    matches.push('(patients.first_name LIKE :patient OR patients.last_name LIKE :patient OR patients.account_number LIKE :patient OR patients.address LIKE :patient)') unless patient.nil?

    @form_values = {:dummy => 1} #put the date field in first by default - there will always be a date to search for.
    @values = {}
    @form_values.merge!({:doctor_field => params[:doctor_field]}) unless doctor.nil?
    @values.merge!({:doctor => doctor}) unless doctor.nil?
    @form_values.merge!({:user_field => params[:user_field]}) unless user.nil?
    @values.merge!({:user => user}) unless user.nil?
    @form_values.merge!({:patient_field => params[:patient_field]}) unless patient.nil?
    @values.merge!({:patient => patient}) unless patient.nil?

# SELECT form_instances.* FROM form_instances,doctors,users,patients WHERE form_instances.doctor_id=doctors.id AND form_instances.user_id=users.id AND form_instances.patient_id=patients.id AND doctors.friendly_name LIKE :doctor AND users.friendly_name LIKE :user AND (patients.first_name LIKE :patient OR patients.last_name LIKE :patient OR patients.account_number LIKE :patient OR patients.address LIKE :patient)

    @result_pages, @results = paginate_by_sql(FormInstance, ["SELECT form_instances.* FROM " + tables.join(',') + " WHERE " + matches.join(' AND '), @values], 30, options={})
    @search_entity = @results.length == 1 ? "Archived Form" : "Archived Forms"
    render :layout => false
  end
  def live_search
    search(true)
  end

#Input: as admin, just call this action on a form
#Returns: redirect to the listing page for the status the form came from.
  def archive
    restrict('allow only admins') or begin
      
    end
  end

  def unarchive
    restrict('allow only admins') or begin
      
    end
  end

end
