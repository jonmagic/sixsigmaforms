require File.dirname(__FILE__) + '/../test_helper'

class AdminTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :admins

  def test_should_create_admin
    assert_difference Admin, :count do
      admin = create_admin
      assert !admin.new_record?, "#{admin.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_email
    assert_no_difference Admin, :count do
      u = create_admin(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_require_friendly_name
    assert_no_difference Admin, :count do
      u = create_admin(:friendly_name => nil)
      assert u.errors.on(:friendly_name)
    end
  end

  def test_registration_should_require_username
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      assert_raises(ActiveRecord::RecordInvalid) { admins(:aaron).update_attributes!(:password => 'password', :password_confirmation => 'password') }
    end
  end

  def test_registration_should_require_password
    assert_no_difference Admin, :count do
      admins(:aaron).changing_login
      assert_raises(ActiveRecord::RecordInvalid) { admins(:aaron).update_attributes!(:username => 'aaron2', :password_confirmation => 'password') }
    end
  end

  def test_should_reset_password
    admins(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal admins(:quentin), Admin.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    admins(:quentin).update_attributes(:username => 'quentin2')
    assert_equal admins(:quentin), Admin.authenticate('quentin2', 'test')
  end

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
