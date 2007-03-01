# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    if params[:doctor_alias] == 'ssadmin'
      self.current_user = Admin.authenticate(params[:username], params[:password])
    else
      self.current_user = User.authenticate(params[:username], params[:password], params[:doctor_alias])
    end
    if logged_in?
      flash[:notice] = "Welcome " + self.current_user.friendly_name + "."
      redirect_back_or_default(doctor_dashboard_url(params[:doctor_alias]))
    else
      if params[:username]
        flash[:notice] = "Invalid username or password."
      end
      render :action => 'new'
    end
  end

  def destroy
    doc_al = self.current_user.domain
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(doctor_login_url(doc_al))
  end
end
