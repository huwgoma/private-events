class ChangeDateTimeInEvents < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :datetime, :event_date
    change_column :events, :event_date, :date
    add_column :events, :time, :time
  end
end
