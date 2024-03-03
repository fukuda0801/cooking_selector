class AddDetailsToDishes < ActiveRecord::Migration[6.1]
  def change
    add_column :dishes, :difficulty, :string
    add_column :dishes, :genre, :string
  end
end
