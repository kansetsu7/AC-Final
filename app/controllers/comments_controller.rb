class CommentsController < ApplicationController
  before_action :set_post ,only: [:create]
  before_action :set_comment ,only: [:edit, :update, :destroy, :cancel]
  before_action :set_user ,only: [:index]

  def index
    @comments = @user.comments
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!
    redirect_to post_path(@post)
  end

  def edit
    render json: {
      commentEditHtml: render_to_string(partial: 'shared/comment_form', locals: {comment: @comment})
    }
  end

  def cancel
    render json: {
      commentCancelHtml: render_to_string(partial: 'shared/comment_content', locals: {comment: @comment})
    }
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "comment was successfully update"
      redirect_back(fallback_location: root_path)
    else
      render :index
      flash[:alert] = 'comment was failed to update'
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      flash[:alert] = 'comment was deleted!'
    else
      flash[:alert] = "you can't delete other's comment"
    end
    
    redirect_back(fallback_location: root_path)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    puts "comment id is #{params[:id]}"
    @comment = Comment.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
