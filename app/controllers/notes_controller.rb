# frozen_string_literal: true

class NotesController < ApplicationController
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
    @note.body = Rinku.auto_link(@note.body, mode=:all,
                                 link_attr=nil, skip_tags=nil)
    if @note.save
      @note.update_category(params[:note][:favorite])
      flash[:success] = 'Note created!'
      ParentManager::Redirector.call(session) { |back| redirect_to back }
    else    
      render 'new'
    end
  end

  def edit
    @note = current_user.notes.find(params[:id])
  end

  def update
    @note = current_user.notes.find(params[:id])
    if @note.update_attributes(note_params)
      @note.update_category(params[:note][:favorite])
      flash[:success] = 'Note updated'
      redirect_to @note.category
    else
      render 'edit'
    end
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
end
