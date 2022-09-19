class Attendance < ApplicationRecord
  belongs_to :attendee, class_name: "User"
  belongs_to :event

  validates :attendee_id, uniqueness: { scope: :event_id, message: "You are already attending" }
  validates :attendee_id, comparison: { other_than: Proc.new { |a| a.event.host.id }, message: "You are the host" }

end
