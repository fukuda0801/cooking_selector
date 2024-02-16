class CreateDishes < ActiveRecord::Migration[6.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.text :description
      t.integer :cook_time
      t.integer :calorie

      t.timestamps
    end
  end
end
