class CreateMymapPictures < ActiveRecord::Migration[5.0]
  def change
    create_table :mymap_pictures do |t|
      t.belongs_to :mymap, foreign_key: true, null: false
      t.string :picture, null: false

      t.timestamps
    end
  end
end
