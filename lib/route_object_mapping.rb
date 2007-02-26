module RouteObjectMapping
  protected

    def current_doctor
      #Is this always what I want to return here?
      @current_doctor ||= logged_in? ? current_user.domain : false
    end
    
    def user_is_ssadmin?
      logged_in? ? current_doctor == 'SSAdmin' : false
    end

    # Store the given user in the session.
    def current_doctor=(new_doctor)
      @current_doctor = new_doctor
    end
    
    def current_form_type
      !FormType.find_by_type(form_type).blank? ? FormType.find_by_type(form_type).type.to_sym : nil
    end
    
    def current_form
      current_form_type.find_by_id(form_id)
    end

    def validate_doctor_and_form_type
     #Keep non-SSAdmin people out of SSAdmin dashboard
      redirect_back_or_default(doctor_dashboard_url(current_user.domain.alias)) if params[:doctor_alias] == "SSAdmin" and logged_in? and !(current_user.domain.alias == "SSAdmin")
     #Keep people out of doctors that are not their own or do not exist
      redirect_if_invalid_doctor_alias(params[:doctor_alias]) if !params[:doctor_alias].blank?
     #Keep people away from form types that don't belong to their doctor or do not exist
      redirect_if_invalid_form_type(params[:form_type]) if !params[:form_type].blank?
    end

  private
    def redirect_if_invalid_doctor_alias(doc_alias)
      if logged_in?
        if !(current_user.doctor.alias == doc_alias)
          store_location
          redirect_to_url(doctor_dashboard_path(current_user.doctor.alias))
        end
      else
        if Doctor.exists?(doc_alias) or doc_alias == "SSAdmin"
          store_location
          redirect_to_url(doctor_login_url(doc_alias))
        else
          redirect_back_or_default('/')
        end
      end
    end
    
    def redirect_if_invalid_form_type(form_type)
      redirect_back_or_default(form_type_chooser_url) if !find_by_type(form_type).blank? and current_doctor.form_ids.include?(find_by_type(form_type).id)
    end
end
