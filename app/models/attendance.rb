class Attendance < ApplicationRecord
  belongs_to :attendee, class_name: "User"
  belongs_to :event

  validate :event_window_closed
  validates :attendee_id, comparison: { other_than: Proc.new { |a| a.event.host.id }, message: "You are the host of this event!" }
  validates :attendee_id, uniqueness: { scope: :event_id, message: "You are already attending this event!" }
  
  private 

  def event_window_closed
    if DateTime.now > event.datetime_of
      errors.add(:event, :already_happened, message: "This event has already happened!")
    end
  end
end
