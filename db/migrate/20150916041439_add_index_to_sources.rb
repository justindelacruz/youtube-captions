class AddIndexToSources < ActiveRecord::Migration
  def change
    add_index :sources, :slug, unique: true
  end
end
