class Api::V1::PostsController < ApiController
  before_action :set_post, only: [:update, :destroy]
  def index
    @posts = Post.all
    render json: {
      data: @posts
    }
  end

  def show
    @post = Post.find_by(id: params[:id])
    if !@post
      render json: {
        message: 'post not found!',
        status: 400
      }
    else
      render json: {
        data: @post
      }
    end
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: {
        message: 'successfully created!',
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def update
    if @post.nil?
      render json: {
        message: 'post not found!',
        status: 400
      }
    elsif @post.update(post_params)
      render json: {
        message: 'successfully updated!',
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end
  
  def destroy
    if @post.nil?
      render json: {
        message: 'post not found!',
        status: 400
      }
    else
      @post.destroy
      render json: {
        message: 'successfully delete!'
      }
    end
  end

  private

    def post_params
      params.permit(:id, :user_id, :title, :content, :status, :authority, :image, category_ids:[])
    end

    def set_post
      @post = Post.find_by(id: params[:id])
    end
end
