class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :datetime
      t.string :location

      t.timestamps
    end
  end
end
