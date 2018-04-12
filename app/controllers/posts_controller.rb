class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @posts = Post.all.page(params[:page]).per(20)
    @categories = Category.all
    @active_name = 'All'
  end

end
