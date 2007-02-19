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
#Request re-activate
# requires username
# requires email

  def test_should_create_new
    assert_difference Admin, :count do
      create_admin
      assert_response :redirect
    end
  end

  def test_should_activate
    assert_no_difference Admin, :count do
      post :activate, :admin => {:username => 'aaronjo', :password => 'dont', :password_confirmation => 'dont', :activation_code => admins(:aaron).activation_code}
      assert flash[:notice] == "Signup complete! aaronjo is ready for login."
      assert_equal admins(:aaron), Admin.authenticate('aaronjo', 'dont')
      assert_response :redirect
    end
  end

  def test_should_require_activation_code_to_activate
    assert_no_difference Admin, :count do
      post :activate, :admin => {:username => 'aaronjo', :password => 'dont', :password_confirmation => 'dont'}
      assert_response :redirect
      assert_not_equal admins(:aaron), Admin.authenticate('aaronjo', 'dont')
    end
  end

  def test_should_require_password_confirmation_to_activate
    assert_no_difference Admin, :count do
      post :activate, :admin => {:username => 'aaronjo', :password => 'dont', :activation_code => admins(:aaron).activation_code}
      assert_not_equal admins(:aaron), Admin.authenticate('aaronjo', 'dont')
    end
  end

  def test_should_require_username_to_activate
    assert_no_difference Admin, :count do
      post :activate, :admin => {:password => 'dont', :password_confirmation => 'dont', :activation_code => admins(:aaron).activation_code}
      assert_not_equal admins(:aaron), Admin.authenticate('aaronjo', 'dont')
    end
  end

  protected
    def create_admin(options = {})
      post :create, :admin => { :email => 'quire@example.com', :friendly_name => 'Quire Quinton' }.merge(options)
    end
end
