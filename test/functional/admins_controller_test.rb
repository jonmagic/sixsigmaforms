require File.dirname(__FILE__) + '/../test_helper'
require 'admins_controller'

# Re-raise errors caught by the controller.
class AdminsController; def rescue_action(e) raise e end; end

class AdminsControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :admins

  def setup
    @controller = AdminsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference Admins, :count do
      create_admin
      assert_response :redirect
    end
  end

  def test_should_require_username_on_signup
    assert_no_difference Admins, :count do
      create_admin(:username => nil)
      assert assigns(:admin).errors.on(:username)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference Admins, :count do
      create_admin(:password => nil)
      assert assigns(:admin).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference Admins, :count do
      create_admin(:password_confirmation => nil)
      assert assigns(:admin).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference Admins, :count do
      create_admin(:email => nil)
      assert assigns(:admin).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_activate_admin
    assert_nil Admins.authenticate('aaron', 'test')
    get :activate, :activation_code => admins(:aaron).activation_code
    assert_redirected_to '/'
    assert_not_nil flash[:notice]
    assert_equal admins(:aaron), Admins.authenticate('aaron', 'test')
  end 

  protected
    def create_admin(options = {})
      post :create, :admin => { :username => 'quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
