ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

#/admins/register
#/users/register
  map.register_admin '/admins/register', :controller => 'admins', :action => 'register'
  map.register_user '/users/register', :controller => 'users', :action => 'register'
#/sessions/[new,create,destroy]
  map.resources :sessions

#/pages/[show, etc]
  map.page '/pages/:stub', :controller => 'pages', :action => 'show', :stub => 'index'

#/logout
  map.connect '/logout', :controller => 'sessions', :action => 'destroy'

#/manage/login
  map.admin_login '/manage/login', :controller => 'sessions', :action => 'create', :domain => 'admin'

#/mydoc/login
  map.doctor_login '/:doctor_alias/login', :controller => 'sessions', :action => 'create', :domain => 'doctor'


# * * * * * * * * * * * * * * * * * * * * * * * *


#/manage/admins/[new,create,show,destroy,etc]
  map.resources :admins, :path_prefix => '/manage', :controller => 'manage/admins'

#/manage/doctors/[new,create,show,destroy,etc]
  map.resources :doctors, :path_prefix => '/manage', :controller => 'manage/doctors'

#/manage/pages/[new,create,show,destroy,etc]
  map.resources :pages, :path_prefix => '/manage'

#/manage/:action/:id
  map.admin_dashboard '/manage/:action/:id', :controller => 'manage/admins', :action => 'dashboard'


# * * * * * * * * * * * * * * * * * * * * * * * *


#/mydoc/patients/:action/:id
  map.resources :patients, :path_prefix => '/:doctor_alias', :collection => { :live_search => :any, :search => :any } #index is search

#/mydoc/users/[new,create,show,destroy,etc]
  map.resources :users, :path_prefix => '/:doctor_alias', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }

#/mydoc/forms/CMS1500/[new,show,edit,etc]
  map.resources :forms, :path_prefix => '/:doctor_alias' do |form|
#/mydoc/forms/CMS1500/157/notes/[show,edit,create]
    form.resources :notes
  end

#/mydoc/forms/chooser
  map.form_type_chooser '/:doctor_alias/forms/chooser', :controller => 'forms', :action => 'chooser'

#/mydoc/profile
  map.doctor_profile '/:doctor_alias/profile', :controller => 'doctors', :action => 'show'

#/mydoc/profile/edit
  map.edit_doctor_profile '/:doctor_alias/profile/edit', :controller => 'doctors', :action => 'edit'

#/mydoc
  map.doctor_dashboard '/:doctor_alias', :controller => 'doctors', :action => 'dashboard'


# * * * * * * * * * * * * * * * * * * * * * * * *


  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
