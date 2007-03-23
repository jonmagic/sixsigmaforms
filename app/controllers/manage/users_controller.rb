class Manage::UsersController < ApplicationController
  layout 'admin'
  in_place_edit_for :user, 'friendly_name'
  in_place_edit_for :user, 'email'

  def index
    @doctor = Doctor.find_by_id(params[:doctor_id])
    @users = User.find_all_by_doctor_id(params[:doctor_id])
  end

  def new
    @doctor = Doctor.find_by_id(params[:doctor_id])
    @user = User.find_by_id(params[:id])
  end

  def show
    @doctor = Doctor.find_by_id(params[:doctor_id])
    @user = User.find_by_id(params[:id])
  end

  def create
    @user = User.new
    @user.friendly_name = params[:user][:friendly_name]
    @user.email = params[:user][:email]
    @user.doctor = Doctor.find_by_id(params[:doctor_id])
    if @user.save
      redirect_back_or_default(manage_users_path)
      flash[:notice] = "User #{@user.friendly_name} has been created."
    else
      render :action => "new"
    end
  end

end
