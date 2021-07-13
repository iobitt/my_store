class User < ApplicationRecord; end

class SetDefaultUserType < ActiveRecord::Migration[6.1]
  def up
    User.in_batches.update_all type: "Manager"
  end
end
