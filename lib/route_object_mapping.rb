module RouteObjectMapping

    def domain
      @domain ||= params[:domain] || 'manage'
    end

    def current_domain
      #Is this always what I want to return here?
      @current_doctor ||= logged_in? ? current_user.domain : nil
    end
    def current_doctor
      current_user.doctor
    end

#These are VERY useful!
    def current_form_model
      current_doctor.form_model(params[:form_type])
    end
    def current_form_instance
      current_form_model.find_by_id(params[:form_id]).instance
    end
    def current_form
      current_form_type.find_by_id(params[:form_id])
    end
    def given_activation_code
      @given_activation_code ||= params[:user] ? params[:user][:activation_code] || params[:activation_code] : params[:activation_code]
    end

#Validate for ACCESS
    def validate_doctor_and_form_type
     #Keep people out of doctors that are not their own or do not exist
      redirect_if_invalid_doctor_alias(domain)
     #Keep people away from form types that don't belong to their doctor or do not exist
      redirect_if_invalid_form_type if !params[:form_type].blank?
    end
    def require_admin_except_for_show
      redirect_if_invalid_doctor_alias('manage') unless params[:action] == 'show'
    end


  private
    def redirect_if_invalid_doctor_alias(domain)
      if logged_in?
        if !(current_user.domain == domain)
          store_location
          redirect_to_url(mydashboard_path(current_user.domain))
        end
      else
        if domain == "manage" or Doctor.exists?(domain)
          store_location
          redirect_to_url(login_url(domain))
        else
          redirect_back_or_default('/')
        end
      end
    end
    
    def redirect_if_invalid_form_type
      redirect_back_or_default(form_type_chooser_url) if !current_form_model and current_doctor.form_ids.include?(find_by_form_type(form_type).id)
    end
end
