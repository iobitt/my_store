class CreateSyncHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :sync_histories do |t|
      t.timestamps
    end
  end
end
