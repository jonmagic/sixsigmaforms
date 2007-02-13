require File.dirname(__FILE__) + '/../test_helper'

class AdminTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :admins

  def test_should_create_user
    assert_difference Admin, :count do
      admin = create_admin
      assert !admin.new_record?, "#{admin.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_username
    assert_no_difference Admin, :count do
      u = create_admin(:username => nil)
      assert u.errors.on(:username)
    end
  end

  def test_should_require_password
    assert_no_difference Admin, :count do
      u = create_admin(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference Admin, :count do
      u = create_admin(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference Admin, :count do
      u = create_admin(:email => nil)
      assert u.errors.on(:email)
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
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
