class CollectsController < ApplicationController
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
    if @collect.user == current_user
      @collect.destroy
      flash[:alert] = 'collected!'
    else
      flash[:alert] = "you can't uncollect other's collect"
    end
    
    redirect_back(fallback_location: root_path)
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
