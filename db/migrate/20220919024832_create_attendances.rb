class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.references :attendee, index: true, foreign_key: false
      t.references :event, index: true, foreign_key: true

      t.timestamps
    end

    add_foreign_key :attendances, :users, column: :attendee_id
  end
end
