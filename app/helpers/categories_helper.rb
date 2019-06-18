module CategoriesHelper
  # Updates favorite status of chain of nesting categories
  # from changed category parent to top category
  def update_parent(category, favorite_token)
    case favorite_token
    when '0'
      change_parent_favorite_to_zero(category)
    when '1'
      change_parent_favorite_to_one(category)
    end
  end

  # Updates all nested categories and notes favorite status
  def update_nested_items(category, favorite_token)
    if category.subcategories.any?
      category.subcategories.each do |subcategory|
        subcategory.update_attribute(:favorite, favorite_token)
        update_nested_items(subcategory, favorite_token)
      end
    elsif category.notes.any?
      category.notes.each { |note| note.update_attribute(:favorite, favorite_token) }
    end
  end


  private

  # Changes parent category favorite staus to 0
  # if one of nested categories favorite status was turned-off
  def change_parent_favorite_to_zero(category)
    return unless category.parent_id

    parent_category = current_user.categories.find(category.parent_id)
    parent_category.update_attribute(:favorite, 0)
    change_parent_favorite_to_zero(parent_category)
  end

  # Changes parent category favorite staus to 1 
  # if all nested categories favorite status was turned-on
  def change_parent_favorite_to_one(category)
    return unless category.parent_id

    return if current_user.categories.where(parent_id: category.parent_id, favorite: 0).any?

    parent_category = current_user.categories.find(category.parent_id)
    parent_category.update_attribute(:favorite, 1)
    change_parent_favorite_to_one(parent_category)
  end
end
