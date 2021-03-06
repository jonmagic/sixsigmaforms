ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

#/sessions/[new,create,destroy]
#  map.resources :sessions

#/pages/[show, etc]
  map.page '/pages/:stub', :controller => 'pages', :action => 'show', :stub => 'index'

#/logout
  map.connect '/logout', :controller => 'sessions', :action => 'destroy'

#/mydoc/login OR /manage/login
  map.admin_login '/sixsigma/login', :controller => 'sessions', :action => 'create_admin'

# * * * * * * * *

  map.test '/test/:action/:id', :controller => 'manage/test', :action => 'dashboard'

# * * * * * * * * * * * * * * * * * * * * * * * *

#* * * * * * *
# A D M I N S *
#* * * * * * *

  map.admin_dashboard                        '/sixsigma',        :controller => 'manage/forms',   :action => 'index'
  map.resources :admins,     :path_prefix => '/sixsigma/manage', :controller => 'manage/admins',  :collection => { :register => :any, :activate => :any, :unactivate => :any, :live_search => :any, :search => :any, :set_user_friendly_name => :any, :set_user_email => :any }
  map.resources :doctors,    :path_prefix => '/sixsigma/manage', :controller => 'manage/doctors', :collection => { :live_search => :any, :search => :any } do |doctor|
    doctor.resources :users, :name_prefix => 'manage_',          :controller => 'manage/users',   :collection => { :live_search => :any, :search => :any, :set_user_friendly_name => :any, :set_user_email => :any }, :member => { :unactivate => :any }
  end
  map.resources :pages, :path_prefix => '/sixsigma/manage',   :controller => 'manage/pages', :name_prefix => 'manage_'
  map.admin_account   '/sixsigma/manage/myaccount/:action',   :controller => 'manage/admins', :action => 'show'

  map.admin_search_forms    '/sixsigma/forms/search', :controller => 'manage/forms', :action => 'search'
  map.admin_live_search_forms    '/sixsigma/forms/live_search', :controller => 'manage/forms', :action => 'live_search'
  map.admin_forms_by_status '/sixsigma/forms/:form_status/:action',                             :controller => 'manage/forms', :action => 'index', :form_status => nil
  map.resources :notes, :path_prefix => '/sixsigma/forms/:form_status/:form_type/:form_id',     :controller => 'manage/notes', :name_prefix => 'admin_'
  map.admin_form_log '/sixsigma/forms/:form_type/:form_id/logs', :controller => 'manage/logs', :action => 'form_logs'
  map.formatted_admin_forms '/sixsigma/forms/:form_status/:action/:form_type/:form_id.:format', :controller => 'manage/forms', :action => 'view',   :format => 'html'
  map.admin_forms           '/sixsigma/forms/:form_status/:form_type/:form_id/:action',         :controller => 'manage/forms', :action => 'view'

# * * * * * * * * * * * * * * * * * * * * * * * *

#* * * * * * * *
# D O C T O R S *
#* * * * * * * *

  map.doctor_dashboard '/doctors/:domain', :controller => 'doctors', :action => 'dashboard'
  map.doctor_login '/doctors/:domain/login', :controller => 'sessions', :action => 'create_user'
  map.doctor_profile '/doctors/:domain/manage/profile/:action', :controller => 'doctors', :action => 'profile'

  map.resources :users, :path_prefix => '/doctors/:domain/manage', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }, :member => { :unactivate => :any }
  map.resources :patients, :path_prefix => '/doctors/:domain', :collection => { :live_search => :any, :search => :any }
  map.user_account '/doctors/:domain/myaccount/:action', :controller => 'users', :action => 'show'

  map.doctor_search_forms      '/doctors/:domain/forms/search',      :controller => 'forms', :action => 'search'
  map.doctor_live_search_forms '/doctors/:domain/forms/live_search', :controller => 'forms', :action => 'live_search'
  map.doctor_forms_by_status '/doctors/:domain/forms/:form_status/:action',                     :controller => 'forms',       :action => 'index', :form_status => nil
  map.resources :notes, :path_prefix => '/doctors/:domain/forms/:form_status/:form_type/:form_id', :name_prefix => 'doctor_'
  map.doctor_form_log '/doctors/:domain/forms/:form_type/:form_id/logs', :controller => 'logs', :action => 'form_logs'
  map.formatted_doctor_forms '/doctors/:domain/forms/:form_status/:form_type/:form_id/:action.:format', :controller => 'forms', :action => 'new', :format => 'html'
  map.doctor_draft '/doctors/:domain/forms/draft/:form_type/new', :controller => 'forms', :action => 'new', :form_status => 'draft'
  map.doctor_forms '/doctors/:domain/forms/:form_status/:form_type/:form_id/:action', :controller => 'forms', :action => 'draft'

# * * * * * * * * * * * * * * * * * * * * * * * *

  map.logs '/manage/logs/:action', :controller => 'logs', :action => 'history'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
#  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
#  map.connect ':controller/:action/:id.:format'
#  map.connect ':controller/:action/:id'
end
