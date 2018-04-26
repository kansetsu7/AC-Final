class UsersController < ApplicationController
  before_action :set_user, only: [:posts]

  def posts
    @posts = @user.posts.where(status: 'Published')
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
