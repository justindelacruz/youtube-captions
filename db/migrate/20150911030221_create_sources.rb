class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :slug
      t.string :name
      t.string :image

      t.timestamps null: false
    end
  end
end
