class Manage::FormsController < ApplicationController
#This class doesn't necessarily sit with the Form model as usual Rails practice - this is the controller for all form actions, and will work with whatever form is specified inparams[:form_type].
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

class String < Object
  def to_status_number
    num = ['draft', 'submitted', 'reviewed', 'accepted', 'archived'].index(self.downcase)
    num.nil? ? nil : num+1
  end
end
