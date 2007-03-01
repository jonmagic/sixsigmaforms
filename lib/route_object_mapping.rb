module RouteObjectMapping

  protected
  
    def domain
      @domain ||= params[:domain] || 'manage'
    end

    def current_domain
      #Is this always what I want to return here?
      @current_doctor ||= logged_in? ? current_user.domain : false
    end
    
    def user_is_admin?
      logged_in? ? current_domain == 'manage' : false
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
#     #Keep non-admin people out of admin dashboard
#      redirect_back_or_default(mydashboard_url(current_user.domain)) if domain == "manage" and logged_in? and !(current_user.domain == "manage")
     #Keep people out of doctors that are not their own or do not exist
      redirect_if_invalid_doctor_alias(domain)
     #Keep people away from form types that don't belong to their doctor or do not exist
      redirect_if_invalid_form_type(params[:form_type]) if !params[:form_type].blank?
    end

    def require_admin_except_for_show
      redirect_if_invalid_doctor_alias('manage') unless params[:action] == 'show'
    end
  private
    def redirect_if_invalid_doctor_alias(doc_alias)
      if logged_in?
        if !(current_user.domain == doc_alias)
          store_location
          redirect_to_url(mydashboard_path(current_user.domain))
        end
      else
        if doc_alias == "manage" or Doctor.exists?(doc_alias)
          store_location
          redirect_to_url(login_url(doc_alias))
        else
          redirect_back_or_default('/')
        end
      end
    end
    
    def redirect_if_invalid_form_type(form_type)
      redirect_back_or_default(form_type_chooser_url) if !find_by_type(form_type).blank? and current_doctor.form_ids.include?(find_by_type(form_type).id)
    end
end
