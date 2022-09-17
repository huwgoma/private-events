class AddHostIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :host
  end
end
