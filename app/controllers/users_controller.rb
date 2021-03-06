class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:posts, :drafts, :edit, :update]
  before_action :check_user, only: [:drafts, :edit, :update]

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = notice 
      redirect_to posts_user_path(@user)
    else
      flash.now[:alert] = 'failed: ' + @post.errors.full_messages.join("<br>").html_safe
      
      set_user
      render :edit
    end
  end

  def posts
    @posts = @user.published_posts
  end

  def drafts
    @drafts = @user.drafts
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end

  def check_user
    unless @user == current_user
      flash[:alert] = "You don't have authority!"
      redirect_back(fallback_location: root_path)
    end
  end
end
