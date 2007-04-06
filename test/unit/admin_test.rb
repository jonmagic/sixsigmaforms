require File.dirname(__FILE__) + '/../test_helper'

class AdminTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :admins

#Create
# require email
# require friendly_name
#Activate
# require username
# require password
# require password_confirmation
#Authenticate
#Can't simply change password

#Create
  def test_should_create
    assert_difference Admin, :count do
      admin = create_admin
      assert !admin.new_record?, "#{admin.errors.full_messages.to_sentence}"
    end
  end

#Create requires email
  def test_create_should_require_email
    assert_no_difference Admin, :count do
      u = create_admin(:email => nil)
      assert u.errors.on(:email)
    end
  end

#Create requires friendly_name
  def test_create_should_require_friendly_name
    assert_no_difference Admin, :count do
      u = create_admin(:friendly_name => nil)
      assert u.errors.on(:friendly_name)
    end
  end

#Activate
  def test_test_should_activate
    assert_no_difference Admin, :count do
      admins(:aaron).update_attributes(:username => 'aaronjo', :password => 'dont', :password_confirmation => 'dont')
      assert admins(:aaron).activate, "Failed to activate: #{admins(:aaron).errors.full_messages.to_sentence}"
#      assert admins(:aaron).activated?
    end
  end

#Activate requires username
  def test_activate_should_require_username
    assert_no_difference Admin, :count do
      admins(:aaron).update_attributes(:password => 'dont', :password_confirmation => 'dont')
      admins(:aaron).activate
      assert !admins(:aaron).activated?
    end
  end

#Activate requires password
  def test_activate_should_require_password
    assert_no_difference Admin, :count do
      admins(:aaron).update_attributes(:username => 'aaronjo', :password_confirmation => 'dont')
      admins(:aaron).activate
      assert !admins(:aaron).activated?
    end
  end

#Activate requires password_confirmation
  def test_activate_should_require_password_confirmation
    assert_no_difference Admin, :count do
      admins(:aaron).update_attributes(:username => 'aaronjo', :password => 'dont')
      admins(:aaron).activate
      assert !admins(:aaron).activated?
    end
  end

#Authenticate
  def test_should_authenticate
    assert_equal admins(:quentin), Admin.authenticate('quentin', 'test')
  end

#Changing login information requires activation_code
  def test_should_not_change_password_if_activation_code_not_present_and_valid
    assert_no_difference Admin, :count do
      admins(:quentin).update_attributes(:username => 'quentin', :password => 'dontnever', :password_confirmation => 'dontnever')
      assert_equal admins(:quentin), Admin.authenticate('quentin', 'test')
      assert_not_equal admins(:quentin), Admin.authenticate('quentin', 'dontnever')
    end
  end

  protected
#    def create_admin(options = {})
#      Admin.create({ :username => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
#    end
    def create_admin(options = {})
      Admin.create({ :email => 'quire@example.com', :friendly_name => 'Quire Faldice' }.merge(options))
    end
end
