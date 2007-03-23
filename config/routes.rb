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

  map.admin_dashboard                     '/sixsigma',        :controller => 'manage/admins', :action => 'dashboard'
  map.resources :admins,  :path_prefix => '/sixsigma/manage', :controller => 'manage/admins', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }
  map.resources :doctors, :path_prefix => '/sixsigma/manage', :controller => 'manage/doctors', :collection => { :live_search => :any, :search => :any } do |doctor|
    doctor.resources :users, :controller => 'manage/users',   :name_prefix => 'manage_', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }
  end
  map.resources :pages, :path_prefix => '/sixsigma/manage',   :controller => 'manage/pages', :name_prefix => 'manage_'
  # map.admin_forms '/sixsigma/forms/:form_status/:action/:form_type/:form_id', :controller => 'manage/forms', :action => 'index', :form_type => nil, :form_id => nil
  map.admin_account   '/sixsigma/manage/myaccount/:action',   :controller => 'manage/admins', :action => 'show'

  map.forms_by_status '/sixsigma/forms/status/:form_status',  :controller => 'manage/forms',  :action => 'index', :form_status => 'all'

  map.formatted_forms '/doctors/:domain/forms/:form_type/:action/:form_id.:format', :controller => 'forms', :form_type => 'chooser', :action => 'new', :format => 'html', :form_id => nil
  map.forms '/sixsigma/forms/:form_type/:action/:form_id', :controller => 'forms', :form_type => 'chooser', :action => 'new', :form_id => nil
  map.resources :notes, :path_prefix => '/sixsigma/forms/:form_type/:form_id'

# * * * * * * * * * * * * * * * * * * * * * * * *

#* * * * * * * *
# D O C T O R S *
#* * * * * * * *

  map.doctor_dashboard '/doctors/:domain', :controller => 'doctors', :action => 'dashboard'
  map.doctor_login '/doctors/:domain/login', :controller => 'sessions', :action => 'create_user'
  map.doctor_profile '/doctors/:domain/profile/:action', :controller => 'doctors', :action => 'profile'

  map.resources :patients, :path_prefix => '/doctors/:domain', :collection => { :live_search => :any, :search => :any }
  map.resources :users, :path_prefix => '/doctors/:domain', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }
  map.myaccount '/doctors/:domain/myaccount/:action', :controller => 'users', :action => 'show'

  map.forms_status '/doctors/:domain/forms/status/:form_status/:action', :controller => 'forms', :form_status => 'all', :action => 'index'
  map.resources :notes, :path_prefix => '/doctors/:domain/forms/:form_type/:form_id'
  map.formatted_forms '/doctors/:domain/forms/:form_type/:action/:form_id.:format', :controller => 'forms', :form_type => 'chooser', :action => 'new', :format => 'html', :form_id => nil
  map.forms '/doctors/:domain/forms/:form_type/:action/:form_id', :controller => 'forms', :form_type => 'chooser', :action => 'new', :form_id => nil

# * * * * * * * * * * * * * * * * * * * * * * * *

  map.logs '/manage/logs/:action', :controller => 'logs', :action => 'history'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
#  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
#  map.connect ':controller/:action/:id.:format'
#  map.connect ':controller/:action/:id'
end
