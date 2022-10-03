class Attendance < ApplicationRecord
  include ActiveModel::Validations
  
  belongs_to :attendee, class_name: "User"
  belongs_to :event

  # Event must be upcoming (ie. not already past)
  validates_with EventUpcomingValidator
  # The attendee cannot be the event's host
  validates :attendee_id, comparison: { other_than: Proc.new { |a| a.event.host.id }, message: "You are the host of this event!" }
  # The attendee cannot already be attending the event
  validates :attendee_id, uniqueness: { scope: :event_id, message: "You are already attending this event!" }
  
  # If creating an Attendance to a Private Event - The attendee must be on the Event's list of invitees
  validates :attendee_id, inclusion: { in: Proc.new { |a| a.event.invitee_ids }, 
    if: Proc.new { |a| a.event.is_private? }, 
    message: "This event is private - you do not have an invite!" }
end
