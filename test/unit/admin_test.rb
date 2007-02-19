require File.dirname(__FILE__) + '/../test_helper'

class AdminTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :admins

# Should create
  def test_should_create_admin
    assert_difference Admin, :count do
      admin = create_admin
      assert !admin.new_record?, "#{admin.errors.full_messages.to_sentence}"
    end
  end

#  Should require email
  def test_should_require_email
    assert_no_difference Admin, :count do
      u = create_admin(:email => nil)
      assert u.errors.on(:email)
    end
  end

#  Should require friendly_name
  def test_should_require_friendly_name
    assert_no_difference Admin, :count do
      u = create_admin(:friendly_name => nil)
      assert u.errors.on(:friendly_name)
    end
  end

# Should activate
  def test_should_activate_admin
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      admins(:aaron).update_attributes(:username => 'aaronjo', :password => 'dont', :password_confirmation => 'dont')
      admins(:aaron).activate
      assert admins(:aaron).activated?
    end
  end

# Should require username
  def test_should_require_username_to_activate
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      admins(:aaron).update_attributes(:password => 'dont', :password_confirmation => 'dont')
      admins(:aaron).activate
      assert !admins(:aaron).activated?
    end
  end

# Should require password
  def test_should_require_password_to_activate
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      admins(:aaron).update_attributes(:username => 'aaronjo', :password_confirmation => 'dont')
      admins(:aaron).activate
      assert !admins(:aaron).activated?
    end
  end

# Should update
  def test_activation_should_require_username
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      admins(:aaron).update_attributes!(:username => 'aaronjo', :password => 'password', :password_confirmation => 'password')
      model.errors[:username].nil?
    end
  end

#  Should require username
  def test_activation_should_require_username
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      assert_raises(ActiveRecord::RecordInvalid) { admins(:aaron).update_attributes!(:password => 'password', :password_confirmation => 'password') }
    end
  end

#  Should require password
  def test_activation_should_require_password
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      assert_raises(ActiveRecord::RecordInvalid) { admins(:aaron).update_attributes!(:username => 'aaron2', :password_confirmation => 'password') }
    end
  end

#  Should require password_confirmation
  def test_activation_should_require_password_confirmation
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      assert_raises(ActiveRecord::RecordInvalid) { admins(:aaron).update_attributes!(:username => 'aaron2', :password => 'password') }
    end
  end

# * * * *
  def test_should_reset_password
    admins(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal admins(:quentin), Admin.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    admins(:quentin).update_attributes(:username => 'quentin2')
    assert_equal admins(:quentin), Admin.authenticate('quentin2', 'test')
  end

# Should destroy

  def test_should_authenticate_admin
    assert_equal admins(:quentin), Admin.authenticate('quentin', 'test')
  end

  protected
#    def create_admin(options = {})
#      Admin.create({ :username => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
#    end
    def create_admin(options = {})
      Admin.create({ :email => 'quire@example.com', :friendly_name => 'Quire Faldice' }.merge(options))
    end
end
