class CategoriesController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy
  include ParentManager

  def index
    @categories = current_user.categories.where(parent_id: nil)
                              .paginate(page: params[:page])
  end

  def show
    @category = current_user.categories.find(params[:id])
    assign_resources
  end

  def new
    ParentManager::Reminder.call(session, request.referrer)
    parent = ParentManager::CategoryProvider.call(session, current_user)
    @category = current_user.categories.build(favorite: parent.favorite)
  end

  def create
    @category = new_category
    save_category
  end

  def edit
    @category = current_user.categories.find(params[:id])
  end

  def update
    @category = current_user.categories.find(params[:id])
    update_category
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

  # Uploads subcategories or notes regarding to
  # which items the category contains.
  def assign_resources
    if @category.subcategories.any?
      @categories = @category.subcategories.paginate(page: params[:page])
    else
      @notes = @category.notes.paginate(page: params[:page])
    end
  end

  def new_category
    parent = ParentManager::CategoryProvider.call(session, current_user)
    category = current_user.categories.build(category_params)
    category.parent_id = parent.id if parent
    category
  end

  def save_category
    if @category.save
      @category.update_related_items(params[:category][:favorite])
      flash[:success] = 'Сategory created!'
      ParentManager::Redirector.call(session) { |back| redirect_to back }
    else
      render 'new'
    end
  end

  def update_category
    if @category.update_attributes(category_params)
      @category.update_related_items(params[:category][:favorite])
      flash[:success] = 'Category updated'
      redirect_to @category.parent || categories_url
    else
      render 'edit'
    end
  end
end
