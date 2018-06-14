class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.belongs_to :mymap, foreign_key: true, null: false
      t.string :name, null: false
      t.integer :types_number, null: false
      t.string :types_name, null: false
      t.text :address, null: false
      t.string :phone_number
      t.text :google_url
      t.text :open_timing, array: true
      t.string :placeId, null: false
      t.text :memo
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
