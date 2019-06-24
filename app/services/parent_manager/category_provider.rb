module ParentManager
  # Returns the category where a new category/note will be added.
  class CategoryProvider < ApplicationService
    def initialize(session, user)
      @session = session
      @user = user
    end

    def call
      uri = URI(@session[:parent_category_url]).path
      parent_path = Rails.application.routes.recognize_path(uri)
      @user.categories.find_by(id: parent_path[:id])
    end
  end
end
