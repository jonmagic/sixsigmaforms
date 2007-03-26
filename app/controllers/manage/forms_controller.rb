class Manage::FormsController < ApplicationController
  layout 'admin'
#This is the Admins' controller for manipulating forms. It isn't very completed yet.

  #GET /forms/:status
  def index
    restrict('allow only admins') or begin
      if params[:form_status].nil?
        redirect_to admin_forms_by_status_path(:form_status => 'submitted')
      else
        @forms = FormInstance.find_all_by_status_number(params[:form_status].as_status.number)
      end
    end
  end

  def view
    restrict('allow only admins') or begin
      @form_instance = FormInstance.find_by_form_data_type_and_form_data_id(params[:form_type], params[:form_id])
      @form = @form_instance.form_data
    end
  end

end

