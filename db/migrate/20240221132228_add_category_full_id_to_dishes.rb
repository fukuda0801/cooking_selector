class AddCategoryFullIdToDishes < ActiveRecord::Migration[6.1]
  def change
    add_column :dishes, :category_full_id, :string
  end
end
