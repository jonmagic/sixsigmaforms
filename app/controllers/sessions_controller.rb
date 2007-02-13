# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    if params[:doctor] == 'SSAdmin'
      self.current_user = Admin.authenticate(params[:username], params[:password])
    else
      self.current_user = User.authenticate(params[:username], params[:password], params[:doctor])
    end
    if logged_in?
      flash[:notice] = "Logged in successfully. Welcome, " + self.current_user.username + "."
      redirect_back_or_default(admins_path)
    else
      if params[:username]
        flash[:notice] = "Invalid username or password."
      end
      render :action => 'new'
    end
  end

  def destroy
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/login')
  end
end
