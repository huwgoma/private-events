class AttendancesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :validate_attendance, only: [:create]

  def create
    current_user.attendances.build(event_id: params[:id]).save
    flash[:notice] = "You are now attending this event."
    redirect_to event_path(params[:id])
  end

  private

  def validate_attendance
    event = Event.find(params[:id])
    
    flash[:alert] = case 
    when event.attendees.include?(current_user)
      "You are already attending this event!"
    when event.host == current_user
      "You are the host of this event!"
    when DateTime.now > event.datetime_of  
      "This event has already happened! (Unless you have a time machine)"
    end
    redirect_to event if alert
  end
end
