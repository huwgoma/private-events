class AttendancesCreator
  def initialize(attendee_id:, event_id:)
    @attendee_id = attendee_id
    @event_id = event_id
  end

  def execute
    attendance = Attendance.create!(attendee_id: @attendee_id, event_id: @event_id)
  rescue ActiveRecord::RecordInvalid => e
    return OpenStruct.new(success?: false, errors: e.record.errors)
  else 
    OpenStruct.new(success?: true, attendance: attendance)
  end
end