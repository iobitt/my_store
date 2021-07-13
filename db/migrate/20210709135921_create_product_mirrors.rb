class CreateProductMirrors < ActiveRecord::Migration[6.1]
  def change
    create_table :product_mirrors do |t|
      t.integer "inner_id"
      t.integer "external_id"
      t.string "name"
      t.integer "quantity"
      t.float "price"
      t.integer "user_id"
      t.datetime "external_created_at"
      t.datetime "external_updated_at"
      t.boolean "is_archived", default: false, null: false
      t.timestamps
    end
  end
end
