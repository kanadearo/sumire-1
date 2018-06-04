class CreatePlacePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :place_pictures do |t|
      t.belongs_to :place, foreign_key: true, null: false
      t.text :picture, null: false

      t.timestamps
    end
  end
end
