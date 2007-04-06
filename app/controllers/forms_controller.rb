class FormsController < ApplicationController
  layout 'doctor'
  before_filter :add_form_restrictions

  def add_form_restrictions
    add_restriction('allow only if valid form type', !current_doctor.form_model(params[:form_type]).nil?) {
      flash[:notice] = "Attempted access of unauthorized form type!"
    } if logged_in? and current_user.is_doctor_user?
  end

  def index
    restrict('allow only doctor users') or begin
      if params[:form_status].nil?
        redirect_to doctor_forms_by_status_path(:form_status => 'drafts')
      elsif params[:form_status] == 'archived'
        render :action => 'archive_view'
      else
        if params[:form_status] == 'all'
          @my_forms = current_user.form_instances
          @others_forms = current_user.others_form_instances
        else
          @my_forms = current_user.forms_with_status(params[:form_status])
          @others_forms = current_user.others_forms_with_status(params[:form_status])
        end
      end
    end
  end

  def archive_view
  end

  #There should be three fields here: Doctor, Patient, Date
    def search(live=false)
      user    = nil
      patient = nil
      date    = nil

      user    = "%" + params[:user_field]    + "%" if !params[:user_field].nil? and params[:user_field].length > 0
      patient = "%" + params[:patient_field] + "%" if !params[:patient_field].nil? and params[:patient_field].length > 0
      date = (!params[:Time][:tomorrow].nil? and params[:Time][:tomorrow].length > 0) ? params[:Time][:tomorrow] : Time.tomorrow
  #Learn how to handle Dates in rails' forms
      # date    = params[:date_field].nil? ? Date.new. : params[:date_field]

  # logger.error "D: #{doctor}/#{params[:doctor_field]}; U: #{user}/#{params[:user_field]}; P: #{patient}/#{params[:patient_field]}; T: #{date}/#{params[:Time][:now]}\n"

      tables = ['form_instances']
      tables.push('users') unless user.nil?
      tables.push('patients') unless patient.nil?

      matches = ["form_instances.doctor_id=:doctor_id AND form_instances.status_number=4 AND form_instances.created_at < :date"] #Put the date field in first by default - there will always be a date to search for.
      matches.push('form_instances.user_id=users.id') unless user.nil?
      matches.push('form_instances.patient_id=patients.id') unless patient.nil?
      matches.push('users.friendly_name LIKE :user') unless user.nil?
      matches.push('(patients.first_name LIKE :patient OR patients.last_name LIKE :patient OR patients.account_number LIKE :patient OR patients.address LIKE :patient)') unless patient.nil?

      @form_values = {:Time => {:tomorrow => date}} #put the date field in first by default - there will always be a date to search for.
      @values = {:date => date, :doctor_id => current_doctor.id}
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

#This is hit first, with an existing OR new patient. The form instance is created and then redirects to the editing ('draft') of the created form.
  def new
    restrict('allow only doctor users') or begin
      return redirect_to(doctor_dashboard_url) if params[:form_type] == 'chooser'
      @patient = Patient.find_by_id(params[:patient_id]) || Patient.create(:doctor => current_doctor)
      return redirect_to doctor_dashboard_path() unless @patient.doctor_id == current_user.doctor_id
      @form_instance = FormInstance.new(
        :user => current_user,
        :doctor => current_doctor,
        :patient => @patient,
        :form_type => current_form_model, #Automatically creates the connected form data via the appropriate (given) model
        :status => 'draft'
      )

      if @form_instance.form_data.update_attributes(@patient.attributes)
        # @form.instance = FormInstance.new(
        #                         :user_id => current_user.id,
        #                         :doctor_id => current_doctor.id,
        #                         :patient_id => @patient.id,
        #                         :form_type => FormType.find_by_form_type(params[:form_type]),
        #                         :form_type_id => FormType.find_by_form_type(params[:form_type]).id,
        #                         :status => 'draft')
        if @form_instance.save
          redirect_to doctor_forms_url(:form_status => 'draft', :form_type => @form_instance.form_data_type, :action => 'draft', :form_id => @form_instance.form_data_id)
        else
          render :action => 'draft'
        end
      else
        render :action => 'draft'
      end
    end
  end

#Actually think of this as 'edit'
  def draft
    restrict('allow only doctor users') or begin
#Redirect to view the form if not allowed to edit
# restrict('')
# * * * *
      @form_type = params[:form_type]
      return redirect_to(doctor_dashboard_url) if @form_type == 'chooser'
      @form = FormType.model_for(@form_type).find_by_id(params[:form_id])
      # Drop the status down to draft!
      if !(@form.instance.status == 'draft')
        @form.instance.status = 'draft'
        @form.instance.save
      end
      @patient = @form.instance.patient
      @values = @form
    end
  end

#This is for submitting edits. This is an ajax-specific function, normally auto-save like gmail but also via a button (like gmail).
  def update
    restrict('allow only doctor users') or begin
      status_changed = false
      @form = FormType.model_for(params[:form_type]).find_by_id(params[:form_id])
      if @form.instance.patient.update_attributes(params[params[:form_type]]) & @form.update_attributes(params[params[:form_type]]) # & @form.instance.update
        @save_status = "Draft saved at " << Time.now.strftime("%I:%M %p").downcase
        if !params[:form_instance].nil? && !params[:form_instance][:status].blank? && !(params[:form_instance][:status] == @form.instance.status)
          @form.instance.status = params[:form_instance][:status]
          if @form.instance.save
            # Log.create(:log_type => 'status:update', :data => {})
            status_changed = true
          else
            flash[:notice] = "ERROR Submitting draft!"
          end
        end
      else
        @save_status = "ERROR auto-saving!"
      end
      respond_to do |format|
        format.html {redirect_to status_changed ? doctor_forms_by_status_url(:form_status => @form.instance.status) : doctor_forms_url(:form_type => @form.instance.form_data_type, :form_id => @form.instance.form_data_id)}
        format.js   {render :layout => false}
      end
    end
  end

  def view
    restrict('allow only doctor users') or begin
      @form_type = params[:form_type]
      @form = FormType.model_for(@form_type).find_by_id(params[:form_id])
    end
  end

  def discard
    restrict('allow only doctor users') or begin
      @form = FormInstance.find_by_form_data_type_and_form_data_id(params[:form_type], params[:form_id])
      @status_count = current_user.forms_with_status(@form.status).count - 1
      @status_link_text_with_count = @form.status.as_status.word('uppercase short plural') + (@status_count == 0 ? '' : " (#{@status_count})")
      @status_container_fill = @status_count == 0 ? "<li>&lt;no current #{params[:form_status].as_status.word('lowercase short plural')}&gt;</li>" : nil
      patient = @form.patient
      @form.destroy
      #Also destroy patient if this is the only existing form for that patient and the patient has only a few values recorded and patient was created in the past 18 hours.
      patient.destroy if patient.form_instances(true).count == 0 and !patient.has_essentials? and patient.created_at > 18.hours.ago
      #****
      respond_to do |format|
        format.html {}
        format.js   {render :layout => false}
      end
    end
  end

end
