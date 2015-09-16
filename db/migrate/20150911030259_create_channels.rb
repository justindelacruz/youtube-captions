class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :slug
      t.string :name
      t.string :image
      t.references :source, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
