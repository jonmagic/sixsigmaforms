class Manage::FormsController < ApplicationController

#This is the Admins' controller for manipulating forms. It isn't very completed yet.
  def draft
  end

  #GET /forms/:status
  def index
    @forms = BasicForm.find_by_status(params[:status].to_status_number)
  end

  private
    def require_admin
      access_denied if !current_user.is_admin?
    end
end

