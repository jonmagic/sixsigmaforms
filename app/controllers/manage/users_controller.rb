class Manage::UsersController < ApplicationController
  layout 'admin'

  def index
    @doctor = Doctor.find_by_alias(params[:doctor_alias])
    @users = User.find_all_by_doctor_id(@doctor)
  end

end
