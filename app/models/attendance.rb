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
end
