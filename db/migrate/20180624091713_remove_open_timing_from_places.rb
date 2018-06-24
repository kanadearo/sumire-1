class RemoveOpenTimingFromPlaces < ActiveRecord::Migration[5.0]
  def change
    remove_column :places, :open_timing, :string
  end
end
