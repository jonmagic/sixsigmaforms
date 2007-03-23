# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_sixsigma_session_id'
  include AuthenticatedSystem
  include RouteObjectMapping
  include AccessControl
  before_filter :initiate_global_env
  before_filter :add_default_restrictions
  before_filter :go_to_where_you_belong # If logged in, teleport to own doctor, If not logged in, teleport to accessed_doctor's login page
  layout 'default'

  def add_default_restrictions
    add_restriction('allow only doctor admins', current_user.is_doctor?) {flash[:notice] = "Only Doctor Admins can access this. Please login with Doctor Admin credentials."; store_location; redirect_to doctor_login_path(accessed_domain)}
    add_restriction('allow only admins', current_user.is_admin?) {flash[:notice] = "Only SixSigma Admins can access this. Please login with SixSigma Admin credentials."; store_location; redirect_to admin_login_path}
  end

#Virtually makes this publicly global for the app.
  def add_restriction(name, condition, &default_block)
    @ACL ||= AccessControlList.new
    @ACL.add_restriction(name, condition, default_block)
  end
  def restrict(name, &block)
    @ACL ||= AccessControlList.new
    @ACL.restrict(name, block)
  end

  private
    def go_to_where_you_belong
      
    end

end
