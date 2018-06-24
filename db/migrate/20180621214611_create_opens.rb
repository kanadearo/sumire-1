class CreateOpens < ActiveRecord::Migration[5.0]
  def change
    create_table :opens do |t|
      t.belongs_to :place, foreign_key: true, null: false
      t.string :time, null: false

      t.timestamps
    end
  end
end
