class Manage::UsersController < ApplicationController
  layout 'admin'

  def index
    @doctor = Doctor.find_by_alias(params[:doctor_alias])
    @users = User.find_all_by_doctor_id(@doctor)
  end

  def new
    @doctor = Doctor.find_by_alias(params[:doctor_alias])
    @user = User.find_by_id(params[:id])
  end

  def create
    @user = User.new
    @user.friendly_name = params[:user][:friendly_name]
    @user.email = params[:user][:email]
    @user.doctor = Doctor.find_by_alias(params[:doctor_alias])
    if @user.save
      redirect_back_or_default(manage_users_path)
      flash[:notice] = "User #{@user.friendly_name} has been created."
    else
      render :action => "new"
    end
  end

end
