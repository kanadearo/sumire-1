class CreateMymaps < ActiveRecord::Migration[5.0]
  def change
    create_table :mymaps do |t|
      t.string :name, null: false
      t.text :comment
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
