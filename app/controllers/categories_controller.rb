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
    @category = current_user.categories.build
    ParentManager::Reminder.call(session, request.referrer)
    parent = ParentManager::CategoryProvider.call(session, current_user)
    favorite_status = parent.favorite if parent
  end

  def create
    @category = current_user.categories.build(category_params)
    parent = ParentManager::CategoryProvider.call(session, current_user)
    @category.parent_id = parent.id if parent
    if @category.save
      @category.update_related_items(params[:category][:favorite])
      flash[:success] = 'Сategory created!'
      ParentManager::Redirector.call(session) { |back| redirect_to back }
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
      @category.update_related_items(params[:category][:favorite])
      flash[:success] = 'Category updated'
      redirect_to @category.parent || categories_url
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

  # Uploads subcategories or notes regarding to
  # which items the category contains.
  def assign_resources
    if @category.subcategories.any?
      @categories = @category.subcategories.paginate(page: params[:page])
    else
      @notes = @category.notes.paginate(page: params[:page])
    end
  end
end
