require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

#Things to test for:
# Create user
#  Require:
#   

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

#  def test_should_require_username
#    assert_no_difference User, :count do
#      u = create_user(:username => nil)
#      assert u.errors.on(:username)
#    end
#  end

#  def test_should_require_password
#    assert_no_difference User, :count do
#      u = create_user(:password => nil)
#      assert u.errors.on(:password)
#    end
#  end

#  def test_should_require_password_confirmation
#    assert_no_difference User, :count do
#      u = create_user(:password_confirmation => nil)
#      assert u.errors.on(:password_confirmation)
#    end
#  end

  def test_should_require_email
    assert_no_difference User, :count do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_require_doctor_id
    assert_no_difference User, :count do
      u = create_user(:doctor_id => nil)
      assert u.errors.on(:doctor_id)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password', 'alphago')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:username => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test', 'alphago')
  end

  def test_should_authenticate_user_with_proper_doctor
    assert_equal users(:quentin), User.authenticate('quentin', 'test', 'alphago')
  end

  def test_should_not_authenticate_user_with_improper_doctor
    assert_not_equal users(:quentin), User.authenticate('quentin', 'test', 'yomagrat')
  end

  protected
    def create_user(options = {})
      User.create({ :username => 'quire', :friendly_name => 'Quire Buddy', :doctor_id => 2, :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
