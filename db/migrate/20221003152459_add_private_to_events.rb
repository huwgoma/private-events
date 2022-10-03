class AddPrivateToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :is_private, :boolean, default: false
  end
end
