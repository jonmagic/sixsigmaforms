class FormsController < ApplicationController

  def draft
    @form_type = params[:form_type]
    return redirect_to mydashboard_url(:domain => params[:domain]) if @form_type == 'chooser'
    @form_type_model = FormType.find_by_form_type(@form_type)
    @form = current_user.doctor.form(@form_type).find_by_id(params[:id]) || current_user.doctor.form(@form_type).new
    @patient = Patient.find_by_id(!@form.form_instance.nil? ? @form.form_instance.patient_id : (params[:patient_id] || (params[:patient].blank? ? nil : params[:patient][:id]))) || Patient.new
    @patient.doctor = current_user.doctor

    @values = @form.new_record? ? @patient : @form
  end

  def create
    @form_type = params[:form_type]
    @form = current_user.doctor.form(@form_type).find_by_id(params[:id])
    return render :action => 'update' if !@form.nil?

    @form_type_model = FormType.find_by_form_type(@form_type)
    @patient = Patient.find_by_id(params[:patient_id] || (params[:patient].blank? ? nil : params[:patient][:id])) || Patient.new(:doctor => current_user.doctor)
    @form = @patient.doctor.form(@form_type).new
    @patient.update_attributes(params[@form_type])
    @form.update_attributes(params[@form_type])
    flash[:notice] = "Start..."
    if @patient.create_or_update
      if @form.create_or_update
        @form.form_instance = FormInstance.new(:user_id => current_user.id, :doctor_id => @patient.doctor.id, :patient_id => @patient.id, :form_type => @form_type_model, :form_type_id => @form_type_model.id, :status => 'draft')
        @form.form_instance.form = @form
        flash[:notice] = flash[:notice]+"<br />\nSaved FormData."
        if @form.form_instance.save
          flash[:notice] = flash[:notice]+"<br />\nSaved FormInstance."
          redirect_to forms_url(:action => 'show', :form_type => @form_type, :id => @form.id)
        else
          flash[:notice] = flash[:notice]+"<br />\nDid NOT save FormInstance."
          render :action => 'draft'
        end
      else
        flash[:notice] = flash[:notice]+"<br />\nDid NOT save FormData OR FormInstance."
        render :action => 'draft'
      end
    else
      flash[:notice] = flash[:notice]+"<br />\nDidn't save Anything!"
    end
  end

  def update
    @form_type = params[:form_type]
    @form_type_model = FormType.find_by_form_type(@form_type)
    @patient = Patient.find_by_id(params[:patient_id] || (params[:patient].blank? ? nil : params[:patient][:id]))
    @form = current_user.doctor.form(@form_type).find_by_id(params[:id])
    
    flash[:notice] = "Start..."
    if @patient.update_attributes(params[@form_type])
      if @form.update_attributes(params[@form_type])
        flash[:notice] = flash[:notice]+"<br />\nSaved FormData."
        if @form.form_instance.update_attributes(:created_at => Time.now)
          flash[:notice] = flash[:notice]+"<br />\nSaved FormInstance."
          redirect_to forms_url(:action => 'show', :form_type => @form_type, :id => @form.id)
        else
          flash[:notice] = flash[:notice]+"<br />\nDid NOT save FormInstance."
          render :action => 'draft'
        end
      else
        flash[:notice] = flash[:notice]+"<br />\nDid NOT save FormData OR FormInstance."
        render :action => 'draft'
      end
    else
      flash[:notice] = flash[:notice]+"<br />\nDidn't save Anything!"
    end
  end

  def show
    @form_type = params[:form_type]
    @form = current_user.doctor.form(@form_type).find_by_id(params[:id])
  end

end
