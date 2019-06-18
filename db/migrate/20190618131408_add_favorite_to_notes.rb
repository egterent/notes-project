class AddFavoriteToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :favorite, :string
  end
end
