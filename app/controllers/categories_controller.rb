class CategoriesController < ApplicationController
  before_action :set_category ,only: [:show]

  def show
    @categories = Category.all
    @posts = @category.posts.page(params[:page]).per(20)
    @active_name = @category.name  
  end

  private

  def set_category
    @category = Category.find(params[:id])
    puts @category.name
  end

end
