class Category < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category', optional: true
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }

  # Returns count of notes in all nested categories
  def nested_notes_count
    return notes.count if notes.any?

    return 0 unless subcategories.any?

    count = 0
    subcategories.each do |category|
      count += category.nested_notes_count
    end
    count
  end
end
