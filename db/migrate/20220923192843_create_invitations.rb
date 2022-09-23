class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invites do |t|
      t.references :inviter
      t.references :invitee
      t.references :event
      t.timestamps
    end
    add_foreign_key :invites, :users, column: :inviter_id
    add_foreign_key :invites, :users, column: :invitee_id
    add_foreign_key :invites, :events, column: :event_id
  end
end
