class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :slug
      t.string :name
      t.string :image
      t.timestamp :date_created
      t.text :description
      t.references :channel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
