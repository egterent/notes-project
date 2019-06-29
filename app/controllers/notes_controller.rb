# frozen_string_literal: true

class NotesController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy

  def index
    @notes = current_user.notes.all
  end

  def show
    @note = current_user.notes.find(params[:id])
  end

  def new
    ParentManager::Reminder.call(session, request.referrer)
    category = ParentManager::CategoryProvider.call(session, current_user)
    @note = current_user.notes.build(favorite: category.favorite,
                                     category_id: category.id)
  end

  def create
    @note = current_user.notes.build(note_params)
    save_note
  end

  def edit
    @note = current_user.notes.find(params[:id])
  end

  def update
    @note = current_user.notes.find(params[:id])
    update_note
  end

  def destroy
    @note = current_user.notes.find(params[:id])
    category = @note.category
    @note.destroy
    redirect_to category
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :favorite, :category_id)
  end

  def correct_user
    @category = current_user.categories.find_by(id: params[:id])
    redirect_to categories_url
  end

  def save_note
    if @note.save
      @note.update_category(params[:note][:favorite])
      flash[:success] = 'Note created!'
      ParentManager::Redirector.call(session) { |back| redirect_to back }
    else
      render 'new'
    end
  end

  def update_note
    if @note.update_attributes(note_params)
      @note.update_category(params[:note][:favorite])
      flash[:success] = 'Note updated'
      redirect_to @note.category
    else
      render 'edit'
    end
  end
end
