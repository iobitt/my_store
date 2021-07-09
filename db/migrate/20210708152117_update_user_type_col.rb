class UpdateUserTypeCol < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :type, false
    add_index :users, :type, algorithm: :concurrently
  end
end
