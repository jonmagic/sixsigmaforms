class Manage::FormsController < ApplicationController
  
  layout 'admin'

#This is the Admins' controller for manipulating forms. It isn't very completed yet.
  def draft
  end

  #GET /forms/:status
  def index
    @forms = FormInstance.find_all_by_status_number(params[:form_status].status_to_number)
  end

  private
    def require_admin
      access_denied if !current_user.is_admin?
    end
end

