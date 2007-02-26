ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"


#/admins/register
#/users/register
  map.register_admin '/admins/register', :controller => 'admins', :action => 'register'
  map.register_user '/users/register', :controller => 'users', :action => 'register'
#/sessions/[new,create,destroy]
#/pages/[show, etc]
  map.resources :sessions, :pages
#/logout
  map.connect '/logout', :controller => 'sessions', :action => 'destroy'
#/mydoc/login
  map.doctor_login '/:doctor_alias/login', :controller => 'sessions', :action => 'create'

#This is a little too complicated, maybe a bit redundant? No?
#/SSAdmin/admins/[new,create,show,destroy,etc]
#/SSAdmin/doctors/[new,create,show,destroy,etc]
  map.resources :admins, :path_prefix => '/SSAdmin'
  map.resources :doctors, :path_prefix => '/SSAdmin'
#/SSAdmin/:action/:id
  map.admin_dashboard '/SSAdmin/:action/:id', :controller => 'admins', :action => 'dashboard'
#****

#/mydoc/patients/:action/:id
  map.resources :patients, :path_prefix => '/:doctor_alias' #index is search
#/mydoc/users/[new,create,show,destroy,etc]    #  map.doctor_user '/:doctor_alias/patients/:action/:id', :controller => 'patients', :action => 'search'
  map.resources :users, :path_prefix => '/:doctor_alias', :collection => { :register => :any, :activate => :any }
#/mydoc/forms/CMS1500/[new,show,edit,etc]            #  map.doctor_user '/:doctor_alias/users/:action/:id', :controller => 'users'
  map.resources :forms, :path_prefix => '/:doctor_alias' do |form|
#/mydoc/forms/CMS1500/157/notes/[show,edit,create]
    form.resources :notes
  end
#  map.doctor_form '/:doctor_alias/forms/:form_type/:action/:id', :controller => 'forms', :action => 'draft'
#/mydoc/forms/chooser
  map.form_type_chooser '/:doctor_alias/forms/chooser', :controller => 'forms', :action => 'chooser'
#  map.form_notes '/:doctor_alias/forms/:form_type/:form_id/notes/:action/:id', :controller => 'notes'
  map.doctor_dashboard '/:doctor_alias', :controller => 'doctors', :action => 'dashboard'

  map.pages '/pages/:stub', :controller => 'pages', :action => 'show', :stub => 'index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
