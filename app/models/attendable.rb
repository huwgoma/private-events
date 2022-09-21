# Namespace for methods that check if an Event is Attendable
module Attendable
  def attendable?
    current_user &&
      event_upcoming? &&
      user_not_already_attending? &&
      user_not_host?
  end

  def event_upcoming?
    DateTime.now.before?(datetime_of)
  end

  def user_not_already_attending?
    attendees.exclude?(current_user)
  end

  def user_not_host?
    host != current_user
  end
end