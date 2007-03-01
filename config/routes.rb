ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

#/sessions/[new,create,destroy]
  map.resources :sessions

#/pages/[show, etc]
  map.page '/pages/:stub', :controller => 'pages', :action => 'show', :stub => 'index'

#/logout
  map.connect '/logout', :controller => 'sessions', :action => 'destroy'

#/mydoc/login OR /manage/login
  map.login '/:domain/login', :controller => 'sessions', :action => 'create'


# * * * * * * * * * * * * * * * * * * * * * * * *


#/manage/admins/[new,create,show,destroy,etc]
  map.resources :admins, :path_prefix => '/manage', :controller => 'manage/admins'

#/manage/doctors/[new,create,show,destroy,etc]
  map.resources :doctors, :path_prefix => '/manage', :controller => 'manage/doctors', :collection => { :live_search => :any, :search => :any }

#/manage/pages/[new,create,show,destroy,etc]
  map.resources :pages, :path_prefix => '/manage', :controller => 'manage/pages'

#/manage/:action/:id
  map.admin_dashboard '/manage', :controller => 'manage/admins', :action => 'dashboard'


# * * * * * * * * * * * * * * * * * * * * * * * *


#/mydoc
  map.mydashboard '/:domain', :controller => 'doctors', :action => 'dashboard'

#/mydoc/patients/:action/:id
  map.resources :patients, :path_prefix => '/:domain', :collection => { :live_search => :any, :search => :any }

#/mydoc/users/[new,create,show,destroy,etc]
  map.resources :users, :path_prefix => '/:domain', :collection => { :register => :any, :activate => :any, :live_search => :any, :search => :any }
  map.myprofile '/:domain/myprofile/:action', :controller => 'users', :action => 'show'

#/mydoc/forms/CMS1500/[new,show,edit,etc]
  map.resources :forms, :path_prefix => '/:domain' do |form|
#/mydoc/forms/CMS1500/157/notes/[show,edit,create]
    form.resources :notes
  end

#/mydoc/forms/chooser
  map.form_type_chooser '/:domain/forms/chooser', :controller => 'forms', :action => 'chooser'


# * * * * * * * * * * * * * * * * * * * * * * * *


  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
