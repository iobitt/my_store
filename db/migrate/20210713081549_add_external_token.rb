class AddExternalToken < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :external_token, :string
  end
end
