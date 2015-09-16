class AddIndexToEpisode < ActiveRecord::Migration
  def change
    add_index :episodes, :slug, unique: true
  end
end
