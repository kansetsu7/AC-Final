class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :check_authority, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction, :current_title

  def index
    if current_user.nil?
      @posts = Post.published.where(authority: 'All')
    else
      @posts = Post.readable_posts(current_user).published
    end
    
    if sort_column == 'latest_time'
      @posts = @posts.includes('comments').order('comments.created_at ' + sort_direction).page(params[:page]).per(20)
    else
      @posts = @posts.order(sort_column + ' ' + sort_direction).page(params[:page]).per(20)  
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
    @category = Category.all
  end

  def edit
  end

  def update
    if params[:commit] == "Save Draft"
      @post.status = 'Draft'
      notice = 'Draft was successfully saved!'
    else
      @post.status = 'Published'
      notice = 'Post was successfully published!'
    end

    if @post.update(post_params)
      flash[:notice] = notice 
      redirect_to post_path(@post)
    else
      flash.now[:alert] = 'failed: ' + @post.errors.full_messages.join("<br>").html_safe
      
      set_post
      # @category = Category.all
      render :edit
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if params[:commit] == "Save Draft"
      @post.status = 'Draft'
      notice = 'Draft was successfully saved!'
    else
      @post.status = 'Published'
      notice = 'Post was successfully published!'
    end

    if @post.save
      flash[:notice] = notice
      redirect_to post_path(@post)
    else
      flash.now[:alert] = 'failed: ' + @post.errors.full_messages.join("<br>").html_safe
      
      @post = Post.new
      @category = Category.all
      render :new
    end

  end

  def destroy

    if @post.user == current_user
      @post.destroy
      flash[:alert] = 'post was deleted!'
    else
      flash[:alert] = "you can't delete other's post"
    end

    if params[:from] == 'draft'
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end
  end

  def feeds
    @users_count = User.count
    @posts_count = Post.where(status: 'Published').count
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

  def check_authority
    unless @post.readable?(current_user)
      flash[:alert] = "You don't have authority to see this post!"
      redirect_back(fallback_location: root_path)
    end
  end

end
