class Category < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id',
                           dependent: :destroy
  belongs_to :parent, class_name: 'Category', optional: true
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  include Enumerable

  # Returns count of notes in all nested categories
  def nested_notes_count
    count = notes.any? ? notes.count : 0
    subcategories.each do |category|
      next unless category.notes.any?

      count += category.notes.count
    end
    count
  end

  # Updates favorite status of all related categories and notes.
  def update_related_items(favorite_token)
    update_subcategories(favorite_token)
    update_notes(favorite_token)
    update_nesting_categories(favorite_token)
  end

  # Updates favorite status of chain of nesting categories
  # from the changed category parent to the top category.
  def update_nesting_categories(favorite_token)
    case favorite_token
    when 0
      change_parent_favorite_to_zero
    when 1
      change_parent_favorite_to_one
    end
  end

  def each(&block)
    if block_given?
      block.call(self)
      return unless subcategories.any?

      subcategories.each do |sub|
        sub.each(&block)
      end
    else
      to_enum(:each)
    end
  end

  protected

  # Updates all nested categories favorite status.
  def update_subcategories(favorite_token)
    return unless subcategories.any?

    subcategories.each do |subcategory|
      subcategory.update_attribute(:favorite, favorite_token)
      subcategory.update_notes(favorite_token)
    end
  end

  # Updates all nested notes favorite status.
  def update_notes(favorite_token)
    return unless notes.any?

    notes.each do |note|
      note.update_attribute(:favorite, favorite_token)
    end
  end

  # Changes the parent category favorite status to 0
  # if one of nested categories favorite status was turned-off
  def change_parent_favorite_to_zero
    return unless parent

    parent.update_attribute(:favorite, 0)
    parent.change_parent_favorite_to_zero
  end

  # Changes the parent category favorite status to 1
  # if all nested categories favorite status was turned-on
  def change_parent_favorite_to_one
    return unless parent

    return if parent.subcategories
                    .where(favorite: 0).any?

    parent.update_attribute(:favorite, 1)
    parent.change_parent_favorite_to_one
  end
end
