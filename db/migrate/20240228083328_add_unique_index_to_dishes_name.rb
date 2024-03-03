class AddUniqueIndexToDishesName < ActiveRecord::Migration[6.1]
  def change
    add_index :dishes, :name, unique: true
  end
end
