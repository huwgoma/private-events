class Invite < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :invitee, class_name: "User"
  belongs_to :event

  # Validations
  # event must be upcoming (joinable)

  # inviter id must = event host
  # invitee id must be unique to the event id 
  # invitee id must not be in the event's attendee_ids
end
