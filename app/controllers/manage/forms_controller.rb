class Manage::FormsController < ApplicationController
  layout 'admin'
#This is the Admins' controller for manipulating forms. It isn't very completed yet.


  #GET /forms/:status
  def index
    @forms = FormInstance.find_all_by_status_number(params[:form_status].as_status.number)
  end

  def view
    @form_instance = FormInstance.find_by_form_data_type_and_form_data_id(params[:form_type], params[:form_id])
    @form = @form_instance.form_data
  end

  private
    def require_admin
      access_denied if !current_user.is_admin?
    end
end

