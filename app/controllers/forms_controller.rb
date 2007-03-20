class FormsController < ApplicationController
  layout 'doctor'

  def index
    @my_forms = current_user.forms_with_status(params[:form_status])
    @others_forms = current_user.others_forms_with_status(params[:form_status])
  end

#This is hit first, with an existing OR new patient. The form instance is created and then redirects to the editing ('draft') of the created form.
  def new
    return redirect_to mydashboard_url() if params[:form_type] == 'chooser'
    @patient = Patient.find_by_id(params[:patient_id]) || Patient.create(:doctor => current_doctor)
    @form_instance = FormInstance.new(
      :user => current_user,
      :doctor => current_doctor,
      :patient => @patient,
      :form_type => current_form_model,
      :status => 'draft'
    )
    # @form = current_doctor.form_model(params[:form_type]).create

    flash[:notice] = "Start..."
    if @form_instance.form_data.update_attributes(@patient.attributes)
      # @form.instance = FormInstance.new(
      #                         :user_id => current_user.id,
      #                         :doctor_id => current_doctor.id,
      #                         :patient_id => @patient.id,
      #                         :form_type => FormType.find_by_form_type(params[:form_type]),
      #                         :form_type_id => FormType.find_by_form_type(params[:form_type]).id,
      #                         :status => 'draft')
      flash[:notice] = flash[:notice]+"<br />\nSaved FormData."
      if @form_instance.save
        flash[:notice] = flash[:notice]+"<br />\nSaved FormInstance."
        redirect_to forms_url(:form_type => @form_instance.form_data_type, :action => 'draft', :form_id => @form_instance.form_data_id)
      else
        flash[:notice] = flash[:notice]+"<br />\nDid NOT save FormInstance."
        render :action => 'draft'
      end
    else
      flash[:notice] = flash[:notice]+"<br />\nDidn't save Anything!"
      render :action => 'draft'
    end
  end

#Actually think of this as 'edit'
  def draft
    @form_type = params[:form_type]
    return redirect_to mydashboard_url() if @form_type == 'chooser'
    @form = FormType.model_for(@form_type).find_by_id(params[:form_id])
    @patient = Patient.find_by_id(@form.instance.patient_id)
    @values = @form
  end

#This is for submitting edits. This is an ajax-specific function, normally auto-save like gmail but also via a button (like gmail).
  def update
    @form = FormType.model_for(params[:form_type]).find_by_id(params[:form_id])
    if @form.patient.update_attributes(params[params[:form_type]]) & @form.update_attributes(params[params[:form_type]]) & @form.instance.update
      # flash[:notice] = "Draft saved."
      @save_status = "Draft saved at " << Time.now.strftime("%I:%M %p").downcase
      if params[:status] == 'submitted'
        redirect_to forms_url(:action => 'show', :form_type => params[:form_type], :form_id => @form.id)
      else
        render :layout => false
      end
    else
      @save_status = "ERROR auto-saving!"
      # flash[:notice] = flash[:notice]+" Patient NOT updated."
    end
  end
  
  def show
    @form_type = params[:form_type]
    @form = FormType.model_for(@form_type).find_by_id(params[:form_id])
  end

  def discard_inline
    #Also destroy patient if this is the only existing form for that patient.
    @draft = FormInstance.find_by_id(params[:form_id])
    @draft.destroy
    @drafts_link_text_with_count = current_user.drafts(true).blank? ? "Drafts" : "Drafts (#{current_user.drafts.count})"
    @drafts_count = current_user.drafts.count
    render :layout => false
  end

#Create this method?
  def discard
  end

end
