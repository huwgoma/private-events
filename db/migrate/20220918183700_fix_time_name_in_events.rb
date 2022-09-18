class FixTimeNameInEvents < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :time, :event_time
  end
end
