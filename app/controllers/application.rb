# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_sixsigma_session_id'
  include AuthenticatedSystem
  include RouteObjectMapping
  before_filter :initiate_global_env
  layout 'default'
  
end
