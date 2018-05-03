class CollectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collect ,only: :destroy
  before_action :set_post ,only: :create
  before_action :set_user ,only: :index

  def index
    @collects = @user.collects
  end

  def create
    @collect = current_user.collects.build(collect_params)
    @collect.save
    puts "collected = #{current_user.collected_posts.include?(@post)}"
  end

  def destroy
    @post = @collect.post
    @collect.destroy if @collect.user == current_user
  end

  private

  def set_collect
    @collect = Collect.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def collect_params
    params.permit(:post_id)
  end
end
