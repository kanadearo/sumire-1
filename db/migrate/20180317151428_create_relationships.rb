class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :follow, foreign_key: { to_table: :users}

      t.timestamps

      t.index [:user_id, :follow_id], unique: true
    end
  end
end
