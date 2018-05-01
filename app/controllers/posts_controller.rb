class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: :show
  helper_method :sort_column, :sort_direction, :current_title

  def index
    if sort_column == 'latest_time'
      @posts = Post.includes('comments').where(status: 'Published').order('comments.created_at ' + sort_direction).page(params[:page]).per(20)
    else
      @posts = Post.where(status: 'Published').order(sort_column + ' ' + sort_direction).page(params[:page]).per(20)  
    end
    
    @categories = Category.all
    @active_name = 'All'
    @current_direction = sort_direction
  end

  def show
    @comment = Comment.new
    @collect = current_user.collects.where(post_id: @post.id).first
  end

  def new
    @post = Post.new
    @post.status = 'Draft'
    @category = Category.all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.status = 'Published'
    if @post.save
      flash[:notice] = 'post was successfully created'
      redirect_to post_path(@post)
    else
      flash.now[:alert] = 'post was failed to create: ' + @post.errors.full_messages.join("<br>").html_safe
      
      @post = Post.new
      @post.status = 'Draft'
      @category = Category.all
      render :new
    end

  end

  def feeds
    @users_count = User.count
    @posts_count = Post.count
    @replies_count = Comment.count

    @chatters = User.order('posts_count DESC').limit(10)
    @popular_posts = Post.order('replies_count DESC').limit(10)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def sort_column
    case params[:sort]

    when 'Replies count'
      return 'replies_count'

    when 'Last replied at'
      return 'latest_time'

    when 'Viewed count'
      return 'viewed_count'
    end

    'id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def current_title
    ['Replies count', 'Last replied at', 'Viewed count'].include?(params[:sort]) ? params[:sort] : 'id'
  end

  def post_params
    params.require(:post).permit(:title, :content, :status, :authority, :image, category_ids:[])
  end

end
