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
      do_render = true
      @form_instance = FormInstance.find_by_form_data_type_and_form_data_id(params[:form_type], params[:form_id])
      @form = @form_instance.form_data
logger.error "Status: #{@form_instance.status} // #{params[:form_status]}=#{params[:form_status].as_status.number}\n"
      if @form_instance.status.as_status.number != params[:form_status].as_status.number and (params[:form_status].as_status.number == 3 or params[:form_status].as_status.number == 4)
        @form_instance.status = params[:form_status]
        @form_instance.save
        if @form_instance.status.as_status.number == 4
          flash[:notice] = "Form &lt; #{@form_instance.admin_visual_identifier} &gt; was archived."
          redirect_to admin_forms_by_status_path(:form_status => 3.as_status.text)
          do_render = false
        end
      end
      render :file => "manage/forms/#{params[:form_status]}_view", :use_full_path => true, :layout => true if do_render
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
    date = (!params[:Time][:tomorrow].nil? and params[:Time][:tomorrow].length > 0) ? params[:Time][:tomorrow] : Time.tomorrow
#Learn how to handle Dates in rails' forms
    # date    = params[:date_field].nil? ? Date.new. : params[:date_field]

# logger.error "D: #{doctor}/#{params[:doctor_field]}; U: #{user}/#{params[:user_field]}; P: #{patient}/#{params[:patient_field]}; T: #{date}/#{params[:Time][:now]}\n"

    tables = ['form_instances']
    tables.push('doctors') unless doctor.nil?
    tables.push('users') unless user.nil?
    tables.push('patients') unless patient.nil?

    matches = ['form_instances.status_number=4 AND form_instances.created_at < :date'] #Put the date field in first by default - there will always be a date to search for.
    matches.push('form_instances.doctor_id=doctors.id') unless doctor.nil?
    matches.push('form_instances.user_id=users.id') unless user.nil?
    matches.push('form_instances.patient_id=patients.id') unless patient.nil?
    matches.push('doctors.friendly_name LIKE :doctor') unless doctor.nil?
    matches.push('users.friendly_name LIKE :user') unless user.nil?
    matches.push('(patients.first_name LIKE :patient OR patients.last_name LIKE :patient OR patients.account_number LIKE :patient OR patients.address LIKE :patient)') unless patient.nil?

    @form_values = {:Time => {:tomorrow => date}} #put the date field in first by default - there will always be a date to search for.
    @values = {:date => date}
    @form_values.merge!({:doctor_field => params[:doctor_field]}) unless doctor.nil?
    @values.merge!({:doctor => doctor}) unless doctor.nil?
    @form_values.merge!({:user_field => params[:user_field]}) unless user.nil?
    @values.merge!({:user => user}) unless user.nil?
    @form_values.merge!({:patient_field => params[:patient_field]}) unless patient.nil?
    @values.merge!({:patient => patient}) unless patient.nil?

# SELECT form_instances.* FROM form_instances,doctors,users,patients WHERE form_instances.doctor_id=doctors.id AND form_instances.user_id=users.id AND form_instances.patient_id=patients.id AND doctors.friendly_name LIKE :doctor AND users.friendly_name LIKE :user AND (patients.first_name LIKE :patient OR patients.last_name LIKE :patient OR patients.account_number LIKE :patient OR patients.address LIKE :patient)

    @result_pages, @results = paginate_by_sql(FormInstance, ["SELECT form_instances.* FROM " + tables.join(',') + " WHERE " + matches.join(' AND ') + " ORDER BY form_instances.created_at DESC", @values], 30, options={})
    @search_entity = @results.length == 1 ? "Archived Form" : "Archived Forms"
    render :layout => false
  end
  def live_search
    search(true)
  end

  def return
    restrict('allow only admins') or begin
      status_changed = false
      @form = FormInstance.find_by_form_data_type_and_form_data_id(params[:form_type], params[:form_id])
      if !params[:form].nil? && params[:form][:status] == 'draft'
        @form.status = 'draft'
        if @form.save
          flash[:notice] = "#{@form.form_identifier} was returned to doctor #{@form.doctor.friendly_name}."
          status_changed = true
        else
          flash[:notice] = "ERROR Submitting draft!"
        end
      end
      respond_to do |format|
        format.html {redirect_to status_changed ? admin_forms_by_status_url(:form_status => 2.as_status.text) : admin_forms_url(:form_type => @form.form_data_type, :form_id => @form.form_data_id)}
      end
    end
  end
end
