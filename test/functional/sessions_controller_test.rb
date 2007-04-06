require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

#  def test_should_login_and_redirect
#    post :create, :login => 'quentin', :password => 'test'
#    assert session[:user]
#    assert_response :redirect
#  end

#  def test_should_fail_login_and_not_redirect
#    post :create, :login => 'quentin', :password => 'bad password'
#    assert_nil session[:user]
#    assert_response :success
#  end

  def test_should_logout
    login_as :quentin
    get :destroy
    assert_nil session[:user]
    assert_response :redirect
  end

  def test_should_delete_token_on_logout
    login_as :quentin
    get :destroy
    assert_equal @response.cookies["auth_token"], []
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
