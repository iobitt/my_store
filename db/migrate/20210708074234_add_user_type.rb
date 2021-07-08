class AddUserType < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :type, :string
    change_column_null :users, :name, true
    change_column_null :users, :password_digest, true
  end
end
