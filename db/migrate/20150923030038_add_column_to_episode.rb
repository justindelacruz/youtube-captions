class AddColumnToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :duration, :interval
  end
end
