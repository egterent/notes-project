module ParentManager
  # Stores the URL of category where a new category/note will be added.
  class Reminder < ApplicationService
    def initialize(session, url)
      @session = session
      @url = url
    end

    def call
      @session[:parent_category_url] = @url
    end
  end
end
