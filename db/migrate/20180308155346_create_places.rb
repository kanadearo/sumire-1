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
      t.string :open_timing
      t.string :placeId, null: false
      t.text :memo

      t.timestamps
    end
  end
end
