class RemoveIndexFromEpisodes < ActiveRecord::Migration
  def change
    remove_index :episodes, :slug
  end
end
