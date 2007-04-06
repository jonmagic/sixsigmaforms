require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users
  fixtures :doctors

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

#Create
# requires friendly_name
# requires email
#Register
# requires activation_code
#Activate
# requires activation_code
# requires username
# requires password
# requires password_confirmation
# cannot change username if doctor_admin
#Request re-activate
# requires username
# requires email

  def test_should_create
    assert_difference User, :count do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_friendly_name_on_signup
    assert_no_difference User, :count do
      create_user(:friendly_name => nil)
      assert assigns(:user).errors.on(:friendly_name)
      assert_response :success
    end
  end
  
  def test_should_require_email_on_signup
    assert_no_difference User, :count do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_activate_user
    assert_no_difference User, :count do
      assert_nil User.authenticate('aaronla', 'test', 'yomagrat')
      post :activate, {:user => {:username => 'aaronla', :password => 'toast', :password_confirmation => 'toast', :activation_code => users(:aron).activation_code}, :doctor_alias => 'yomagrat'}
      assert flash[:notice] == "Signup complete! aaronla is ready for login.", "User was not activated."
      assert_equal users(:aron), User.authenticate('aaronla', 'toast', 'yomagrat')
      assert_response :redirect
    end
  end 

  def activation_should_not_allow_username_change_for_doctor_admins
    assert_no_difference User, :count do
     post :activate, {:user => {:username => 'boyning', :password => 'test1', :password_confirmation => 'test1', :activation_code => users(:alphago).activation_code}, :doctor_alias => 'alphago'}
      assert_not_equal users(:alphago), User.authenticate('boyning', 'test1', 'alphago')
      assert_equal users(:alphago), User.authenticate('alphago', 'test', 'alphago')
    end
  end

  protected
    def create_user(options = {})
      post :create, {:doctor_alias => 'yomagrat', :user => { :email => 'quire@example.com', 
        :friendly_name => 'Quire Quigley' }.merge(options)}
    end
end
