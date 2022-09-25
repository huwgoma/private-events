# Validate that an event's join window is still open
class EventUpcomingValidator < ActiveModel::Validator
  def validate(record)
    unless record.event.upcoming?
      record.errors.add(:base, :invalid, message: "This event has already happened!")
    end
  end
end