class FormsController < ApplicationController

#This is hit first, with an existing OR new patient. The form instance is created and then redirects to the editing ('draft') of the created form.
  def new
    return redirect_to mydashboard_url(:domain => params[:domain]) if params[:form_type] == 'chooser'
    @patient = Patient.find_by_id(params[:patient_id]) || Patient.create(:doctor => current_doctor)
    @form_instance = FormInstance.new(
      :user => current_user,
      :doctor => current_doctor,
      :patient => @patient,
      :form_type => current_form_type,
      :status => 'draft'
    )
    # @form = current_doctor.form_model(params[:form_type]).create

    flash[:notice] = "Start..."
    if @form.update_attributes(@patient.attributes)
      # @form.instance = FormInstance.new(
      #                         :user_id => current_user.id,
      #                         :doctor_id => current_doctor.id,
      #                         :patient_id => @patient.id,
      #                         :form_type => FormType.find_by_form_type(params[:form_type]),
      #                         :form_type_id => FormType.find_by_form_type(params[:form_type]).id,
      #                         :status => 'draft')
      flash[:notice] = flash[:notice]+"<br />\nSaved FormData."
      if @form.form_instance.save
        flash[:notice] = flash[:notice]+"<br />\nSaved FormInstance."
        redirect_to forms_url(:domain => current_doctor.alias, :form_type => @form.type.name, :action => 'draft', :id => @form.id)
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
    return redirect_to mydashboard_url(:domain => params[:domain]) if @form_type == 'chooser'
    @form = current_user.doctor.form(@form_type).find_by_id(params[:id])
    @patient = Patient.find_by_id(@form.form_instance.patient_id)
    @values = @form
  end

#This is for submitting edits. This is an ajax-specific function, normally auto-save like gmail but also via a button (like gmail).
  def update
    @form = current_doctor.form(params[:form_type]).find_by_id(params[:id])
    # flash[:notice] = ""
    if @form.patient.update_attributes(params[params[:form_type]]) & @form.update_attributes(params[params[:form_type]]) & @form.form_instance.update
      # flash[:notice] = flash[:notice]+" Draft saved."
      if params[:status] == 'submitted'
        redirect_to forms_url(:action => 'show', :form_type => @form_type, :id => @form.id)
      else
        render :layout => false
        # render :partial => 'updated', :layout => false
      end
    else
      # flash[:notice] = flash[:notice]+" Patient NOT updated."
    end
  end
  
  def show
    @form_type = params[:form_type]
    @form = current_user.doctor.form(@form_type).find_by_id(params[:id])
  end

# (rename to "destroy")
  def discard
    #Also destroy patient if this is the only existing form for that patient.
  end

end
