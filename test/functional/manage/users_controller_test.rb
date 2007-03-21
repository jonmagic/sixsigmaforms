require File.dirname(__FILE__) + '/../../test_helper'
require 'manage/users_controller'

# Re-raise errors caught by the controller.
class Manage::UsersController; def rescue_action(e) raise e end; end

class Manage::UsersControllerTest < Test::Unit::TestCase
  def setup
    @controller = Manage::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
