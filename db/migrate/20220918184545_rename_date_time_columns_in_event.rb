class RenameDateTimeColumnsInEvent < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :event_date, :date_of
    rename_column :events, :event_time, :time_of
  end
end
