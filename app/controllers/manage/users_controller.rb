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
      redirect_back_or_default(manage_users_url)
      flash[:notice] = "User #{@user.friendly_name} has been created."
    else
      render :action => "new"
    end
  end

#This would be better as rjs, with the typical fade out deletion.
  def destroy
    @user = User.find_by_id(params[:id])
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to manage_users_url }
        format.xml  { head :ok }
      end
    else
      
    end
  end

end
