class AddForeignKeyConstraintToEvents < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :events, :users, column: :host_id
  end
end
