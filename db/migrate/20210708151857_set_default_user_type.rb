class SetDefaultUserType < ActiveRecord::Migration[6.1]
  def up
    User.update_all type: "Manager"
  end
end
