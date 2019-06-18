class AddFavoriteToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :favorite, :string
  end
end
