class Api::V1::PostsController < ApiController
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
        message: 'cannot find post!',
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

  private

    def post_params
      params.permit(:user_id, :title, :content, :status, :authority, :image, category_ids:[])
    end
end
