class CreateUserMymaps < ActiveRecord::Migration[5.0]
  def change
    create_table :user_mymaps do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :mymap, foreign_key: true

      t.timestamps

      t.index [:user_id, :mymap_id], unique: true
    end
  end
end
