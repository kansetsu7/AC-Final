class CategoriesController < ApplicationController
  before_action :set_category ,only: [:show]
  helper_method :sort_column, :sort_direction, :current_title

  def show
    if sort_column == 'latest_time'
      @posts = @category.posts.includes('comments').order('comments.created_at '+ sort_direction).page(params[:page]).per(20) 
    else
      @posts = @category.posts.order(sort_column + ' ' + sort_direction).page(params[:page]).per(20) 
    end
    @categories = Category.all
    @active_name = @category.name  
  end

  private

  def set_category
    @category = Category.find(params[:id])
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

end
