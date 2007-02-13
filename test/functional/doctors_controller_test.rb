require File.dirname(__FILE__) + '/../test_helper'
require 'doctors_controller'

# Re-raise errors caught by the controller.
class DoctorsController; def rescue_action(e) raise e end; end

class DoctorsControllerTest < Test::Unit::TestCase
  fixtures :doctors

  def setup
    @controller = DoctorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:doctors)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_doctor
    old_count = Doctor.count
    post :create, :doctor => { }
    assert_equal old_count+1, Doctor.count
    
    assert_redirected_to doctor_path(assigns(:doctor))
  end

  def test_should_show_doctor
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_doctor
    put :update, :id => 1, :doctor => { }
    assert_redirected_to doctor_path(assigns(:doctor))
  end
  
  def test_should_destroy_doctor
    old_count = Doctor.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Doctor.count
    
    assert_redirected_to doctors_path
  end
end
