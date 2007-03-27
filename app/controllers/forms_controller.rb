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
        redirect_to doctor_forms_by_status_path(:form_status => 'submitted')
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

#This is hit first, with an existing OR new patient. The form instance is created and then redirects to the editing ('draft') of the created form.
  def new
    restrict('allow only doctor users') or begin
      return redirect_to(doctor_dashboard_url) if params[:form_type] == 'chooser'
      @patient = Patient.find_by_id(params[:patient_id]) || Patient.create(:doctor => current_doctor)
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
        if @form.instance.save
          Log.create(:log_type => 'status:update', :data => {})
        end
      end
      @patient = Patient.find_by_id(@form.instance.patient_id)
      @values = @form
    end
  end

#This is for submitting edits. This is an ajax-specific function, normally auto-save like gmail but also via a button (like gmail).
  def update
    restrict('allow only doctor users') or begin
      status_changed = false
      @form = FormType.model_for(params[:form_type]).find_by_id(params[:form_id])
      if @form.patient.update_attributes(params[params[:form_type]]) & @form.update_attributes(params[params[:form_type]]) # & @form.instance.update
        @save_status = "Draft saved at " << Time.now.strftime("%I:%M %p").downcase
        if !params[:form_instance].nil? && !params[:form_instance][:status].blank? && !(params[:form_instance][:status] == @form.instance.status)
          @form.instance.status = params[:form_instance][:status]
          if @form.instance.save
            Log.create(:log_type => 'status:update', :data => {})
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
      @form = FormInstance.find_by_id(params[:form_id])
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
