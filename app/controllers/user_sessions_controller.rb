# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'doctor'

  # render new.rhtml
  def new
#Could check for a valid doctor (params[:domain]) and show an alternative login form (using email address) if not found.
  end

  def create
    user = User.valid_username?(params[:username])
    if !user.blank?
      self.current_user = User.authenticate(params[:username], params[:password], params[:domain])
      if logged_in?
        flash[:notice] = "Welcome " + self.current_user.friendly_name + "."
        redirect_back_or_default doctor_dashboard_url(self.current_user.doctor.alias)
      else
        flash[:notice] = "Failed to log in."
        render :action => 'new'
      end
    else
      flash[:notice] = "Invalid username." if params[:username]
      render :action => 'new'
    end
  end

  def destroy
    if logged_in?
      domain = self.current_user.domain
      cookies.delete :auth_token
      reset_session
      flash[:notice] = "You have been logged out."
      redirect_back_or_default(domain == 'sixsigma' ? admin_login_url : doctor_login_url(domain))
    else
      redirect_to page_url
    end
  end
end
