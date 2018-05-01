class UsersController < ApplicationController
  before_action :set_user, only: [:posts, :drafts]

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
end
