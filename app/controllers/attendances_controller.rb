class AttendancesController < ApplicationController
  # Require User to be logged in to create an Attendance
  before_action :authenticate_user!, only: [:create]
  before_action :verify_public_event, only: [:create]

  def create
    @attendance = AttendancesCreator.call(attendee_id: current_user.id, event_id: params[:id])
    if @attendance.success?
      flash[:notice] = "You are now attending this event."
    else
      flash[:alert] = @attendance.errors.messages.values.flatten.first
    end
    redirect_to event_path
  end

  def destroy
    current_user.attendances.find_by(event_id: params[:id]).destroy
    flash[:notice] = "You are no longer attending this event."
    redirect_to event_path
  end

  private

  def verify_public_event
    event = Event.find(params[:id])
    if event.is_private?
      flash[:alert] = "This event is private - you do not have an invite!"
      redirect_to event_path
    end
  end
end
