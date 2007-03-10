ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

#/sessions/[new,create,destroy]
#  map.resources :sessions

#/pages/[show, etc]
  map.page '/pages/:stub', :controller => 'pages', :action => 'show', :stub => 'index'

#/logout
  map.connect '/logout', :controller => 'sessions', :action => 'destroy'

#/mydoc/login OR /manage/login
  map.login '/:domain/login', :controller => 'sessions', :action => 'create'


# * * * * * * * *

  map.test '/test/:action/:id', :controller => 'manage/test', :action => 'dashboard'

# * * * * * * * * * * * * * * * * * * * * * * * *

#* * * * * * *
# A D M I N S *
#* * * * * * *

#/manage/admins/[new,create,show,destroy,etc]
  map.resources :admins, :path_prefix => '/manage', :controller => 'manage/admins', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }

#/manage/doctors/[new,show,etc]
  map.resources :doctors, :path_prefix => '/manage', :controller => 'manage/doctors', :collection => { :live_search => :any, :search => :any }

#/manage/pages/[new,create,show,destroy,etc]
  map.resources :pages, :path_prefix => '/manage', :name_prefix => 'manage_', :controller => 'manage/pages'

#/manage
  map.admin_dashboard '/manage', :controller => 'manage/admins', :action => 'dashboard'
  map.admin_account '/manage/myaccount/:action', :controller => 'manage/admins', :action => 'show'

#Do we want admins to use a different controller for forms than doctors?
#/forms/:status
#The following may conflict with map.resources :forms, below.
  map.admin_forms '/forms/:status', :controller => 'manage/forms', :action => 'index'

# * * * * * * * * * * * * * * * * * * * * * * * *

#* * * * * * * *
# D O C T O R S *
#* * * * * * * *

#/mydoc
  map.mydashboard '/:domain', :controller => 'doctors', :action => 'dashboard'

#/mydoc/patients/:action/:id
  map.resources :patients, :path_prefix => '/:domain', :collection => { :live_search => :any, :search => :any }

#/mydoc/users/[new,create,show,destroy,etc]
  map.resources :users, :path_prefix => '/:domain', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }
  map.myaccount '/:domain/myaccount/:action', :controller => 'users', :action => 'show'

  map.forms_status '/:domain/forms/status/:form_status/:action', :controller => 'forms', :form_status => 'list'
  map.resources :notes, :path_prefix => '/:domain/forms/:form_type/:form_id'
  map.forms '/:domain/forms/:form_type/:action/:id', :controller => 'forms', :form_type => 'chooser', :action => 'draft'

#THIS doesn't actually work because Forms is not a model.
#/mydoc/forms/CMS1500/[new,show,edit,etc]
#  map.resources :forms, :path_prefix => '/:domain' do |form|
#/mydoc/forms/CMS1500/157/notes/[show,edit,create]
#    form.resources :notes
#  end

#/mydoc/forms/chooser
  map.form_type_chooser '/:domain/forms/chooser', :controller => 'forms', :action => 'chooser'


# * * * * * * * * * * * * * * * * * * * * * * * *


  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
#  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
#  map.connect ':controller/:action/:id.:format'
#  map.connect ':controller/:action/:id'
end
