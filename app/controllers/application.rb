# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_sixsigma_session_id'
  include AuthenticatedSystem
  include RouteObjectMapping
  include AccessControl
  before_filter :add_default_restrictions
  before_filter :go_to_where_you_belong
  layout 'default'

  def add_default_restrictions
    add_restriction('allow only doctor admins', current_user.is_doctor?) {flash[:notice] = "Only Doctor Admins can access this. Please login with Doctor Admin credentials."; store_location; redirect_to doctor_login_path(accessed_domain)}
    add_restriction('allow only admins or doctor admins', current_user.is_doctor_or_admin?) {flash[:notice] = "Only Doctor Admins can access this. Please login with Doctor Admin credentials."; store_location; redirect_to doctor_login_path(accessed_domain)}
    add_restriction('allow only doctor users', current_user.is_doctor_user?) {flash[:notice] = "Only Doctor Users can access this. Please login."; store_location; redirect_to doctor_login_path(accessed_domain)}
    add_restriction('allow only admins', current_user.is_admin?) {flash[:notice] = "Only Admins can access this. Please login."; store_location; redirect_to(admin_login_path)}
  end

#Virtually makes this publicly global for the app.
  def add_restriction(name, condition, &default_block)
    @ACL ||= AccessControlList.new
    @ACL.add_restriction(name, condition, default_block)
  end
  def restrict(name, &block)
    @ACL ||= AccessControlList.new
    logger.error "RESTRICTED" unless @ACL.restrictions[name][:condition]
    @ACL.restrict(name, block)
  end

  def paginate_by_sql(model, sql, per_page, options={})
    if options[:count]
      if options[:count].is_a? Integer
        total = options[:count]
      else
        total = model.count_by_sql(options[:count])
      end
    else
      total = model.count_by_sql_wrapping_select_query(sql)
    end
    object_pages = Paginator.new self, total, per_page, params[:page]
    objects = model.find_by_sql_with_limit(sql, object_pages.current.to_sql[1], per_page)
    return [object_pages, objects]
  end

  private
    # If logged in, teleport to own doctor, If not logged in, teleport to accessed_doctor's login page
    def go_to_where_you_belong
      
    end

end
