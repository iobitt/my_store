class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :quantity
      t.float :price
      t.integer :user_id
      t.timestamps
    end
  end
end
