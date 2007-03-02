class FormsController < ApplicationController
#This class doesn't necessarily sit with the Form model as usual Rails practice - this is the controller for all form actions, and will work with whatever form is specified inparams[:form_type].
  def draft
    if params[:form_type] == 'chooser'
      render 'index'
    else
      
    end
  end

  #GET /:domain/forms
  def index
    #This is the chooser for form types.
  end

  private
    def require_admin
      access_denied if !current_user.is_admin?
    end
end
