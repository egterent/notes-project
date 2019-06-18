class CategoriesController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy
  include CategoriesHelper

  def index
    @categories = current_user.categories.where(parent_id: nil)
                              .paginate(page: params[:page])
  end

  def show
    @category = current_user.categories.find(params[:id])
    assign_resources
  end

  def new
    store_parent_category_url
    @category = current_user.categories.build
    @category.favorite = current_user.categories.find(parent_category_id).favorite if parent_category_id 
  end

  def create
    @category = current_user.categories.build(category_params)
    @category.parent_id = parent_category_id
    if @category.save
      flash[:success] = 'Сategory created!'
      redirect_to_parent_category
    else
      render 'new'
    end
  end

  def edit
    @category = current_user.categories.find(params[:id])
  end

  def update
    @category = current_user.categories.find(params[:id])
    if @category.update_attributes(category_params)
      update_nested_items(@category, params[:category][:favorite])
      update_parent(@category, params[:category][:favorite])
      flash[:success] = 'Category updated'
      parent_category = current_user.categories.find(@category.parent_id) if @category.parent_id
      redirect_to parent_category || categories_url
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:success] = 'Category deleted'
    redirect_to request.referrer || categories_url
  end

  private

  def category_params
    params.require(:category).permit(:name, :favorite)
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
