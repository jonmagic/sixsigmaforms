require File.dirname(__FILE__) + '/../test_helper'
require 'notes_controller'

# Re-raise errors caught by the controller.
class NotesController; def rescue_action(e) raise e end; end

class NotesControllerTest < Test::Unit::TestCase
  fixtures :notes

  def setup
    @controller = NotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:notes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_note
    old_count = Note.count
    post :create, :note => { }
    assert_equal old_count+1, Note.count
    
    assert_redirected_to note_path(assigns(:note))
  end

  def test_should_show_note
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_note
    put :update, :id => 1, :note => { }
    assert_redirected_to note_path(assigns(:note))
  end
  
  def test_should_destroy_note
    old_count = Note.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Note.count
    
    assert_redirected_to notes_path
  end
end
