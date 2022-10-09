class RenameDateTimeInEvents < ActiveRecord::Migration[7.0]
  def change
    #remove_column :events, :date_of
    #remove_column :events, :time_of
    add_column :events, :datetime_of, :datetime
  end
end
