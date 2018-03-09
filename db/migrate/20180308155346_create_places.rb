class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :mymap, foreign_key: true, optional: true
      t.string :name, null: false
      t.string :type, null: false
      t.text :adress, null: false
      t.string :phone_number
      t.text :google_url
      t.string :open_timing
      t.string :placeId, null: false
      t.text :memo

      t.timestamps
    end
  end
end
