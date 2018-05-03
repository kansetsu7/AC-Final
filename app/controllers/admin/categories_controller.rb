class Admin::CategoriesController < Admin::BaseController
  before_action :set_category ,only: [:edit, :update, :destroy, :cancel]

  def index
    @categories = Category.all
    if params[:id]
      set_category
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    @category.save!
    redirect_to admin_categories_path
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
      flash[:notice] = "category \"#{@category.name}\" was successfully updated"
    else
      flash.now[:alert] = 'category was failed to update'
      @categories = Category.all
      render :index
    end
  end

  def destroy
    if @category.posts.any?
      flash[:alert] = "Can't delete category!"
    else
      @category.destroy      
    end
    redirect_to admin_categories_path
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
