class CategoriesController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy

  def index
    @categories = current_user.categories.where(parent_id: nil)
                              .paginate(page: params[:page])
  end

  def show
    @category = current_user.categories.find(params[:id])
    assign_resources
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      flash[:success] = 'Сategory created!'
      redirect_to @category
    else
      render 'new'
    end
  end

  def destroy
    @category.destroy
    flash[:success] = 'Category deleted'
    redirect_to request.referrer || categories_url
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def correct_user
    @category = current_user.categories.find_by(id: params[:id])
    redirect_to categories_url if @category.nil?
  end

  def assign_resources
    if @category.subcategories.any?
      @categories = @category.subcategories.paginate(page: params[:page])
    else
      @notes = @category.notes.paginate(page: params[:page])
    end
  end
end
