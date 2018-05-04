class Admin::UsersController < ApplicationController
  before_action :set_user, only: :update
  def index
    @users = User.all.page(params[:page]).per(20)
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "user \"#{@user.name}\"'s role' was successfully updated"
    else
      flash.now[:alert] = 'user was failed to update'
    end
    redirect_to admin_users_path

  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:role)
    end
end
