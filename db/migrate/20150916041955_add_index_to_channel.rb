class AddIndexToChannel < ActiveRecord::Migration
  def change
    add_index :channels, :slug, unique: true
  end
end
