class CreateCaptions < ActiveRecord::Migration
  def change
    create_table :captions do |t|
      t.string :text
      t.float :start_time
      t.float :end_time
      t.references :episode, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
