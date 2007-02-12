ActionController::Routing::Routes.draw do |map|
  
#URLs for doctors in SixSigma's HipForms
#  all prepended with "doctorbusinessname.hipforms.com"
#
#/createUser
#  AJAX interface, under which we have things like the account type:
#    /createUser/FormUser
#  which will show the create user form. Once submitted to the same url,
#  a registration token link is shown and emailed to the email given.
#/createLogin?token=a389bqv98y7qb239nc
#  simple form to fill in the user's name, username/password, [employee number].
#  this logs the user in as well.
#
#/, /login
#  Logs user in. Automatically detects user or business administrator.
#/logout
#  Logs out.

  map.resources :sessions
  map.resources :doctors, :collection => 'activate' do |doctor|
    doctor.resources :users, :collection => 'activate'
  end
  map.connect '', :controller => "sessions", :action => 'new'


#  map.connect '/createUser/:usertype', :controller => 'users', :action => 'new', :usertype => nil
#  map.login '/login', :controller => 'sessions', :action => 'new', :requirements => {:method => :get}
#  map.login '/login', :controller => 'sessions', :action => 'create', :requirements => {:method => :post}
#  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
#  map.connect ':controller/:action/:id.:format'
#  map.connect ':controller/:action/:id'
end
