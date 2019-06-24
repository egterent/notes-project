module ParentManager
  # Redirects to the new category/note parent category
  # or to category index.
  class Redirector < ApplicationService
    def initialize(session, &block)
      @session = session
      @block = block
    end

    def call
      @block.call(@session[:parent_category_url])
      @session.delete(:parent_category_url)
    end
  end
end
