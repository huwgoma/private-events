class Invite < ApplicationRecord
  include ActiveModel::Validations 

  belongs_to :inviter, class_name: "User"
  belongs_to :invitee, class_name: "User"
  belongs_to :event

  # For batch invites
  attr_accessor :user_ids

  # Event must be upcoming
  validates_with EventUpcomingValidator
  # Inviter must be the event host
  validates :inviter_id, comparison: { equal_to: Proc.new { |i| i.event.host.id }, message: "You must be the host of this event to invite users!" }
  # Invitee must not be the event host
  validates :invitee_id, comparison: { other_than: Proc.new { |i| i.event.host.id }, message: "You are the host of this event!" }
  # Invitee must be unique to the event
  validates :invitee_id, uniqueness: { scope: :event_id, message: "This user has already been invited to this event!" }
  # Invitee must not be attending already
  validates :invitee_id, exclusion: { in: -> (i) { i.event.attendee_ids }, message: "This user is already attending this event!" }
end
