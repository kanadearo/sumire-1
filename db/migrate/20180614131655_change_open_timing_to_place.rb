class ChangeOpenTimingToPlace < ActiveRecord::Migration[5.0]
  def change
    change_column :places, :open_timing, :string
  end
end
