# frozen_string_literal: true

class Note < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1 }
  belongs_to :category
  validates :category_id, presence: true
  belongs_to :user
  validates :user_id, presence: true

  # Updates favorite status of chain of nesting categories
  # from the changed note category to the top category.
  def update_category(favorite_token)
    case favorite_token
    when '0'
      category.update_attribute(:favorite, '0')
    when '1'
      unless category.notes.where(favorite: '0').any?
        category.update_attribute(:favorite, '1')
      end
    end
    category.update_nesting_categories(favorite_token)
  end
end
