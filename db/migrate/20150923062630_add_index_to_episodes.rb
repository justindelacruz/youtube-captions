class AddIndexToEpisodes < ActiveRecord::Migration
  def change
    add_index :episodes, [:channel_id, :slug], unique: true
  end
end
