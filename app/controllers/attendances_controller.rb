class AttendancesController < ApplicationController
  # Require User to be logged in to create an Attendance
  before_action :authenticate_user!, only: [:create]

  def create
    @attendance = current_user.attendances.build(event_id: params[:id])
    if @attendance.save
      flash[:notice] = "You are now attending this event."
    else
      # Surely you can do this better?
      flash[:alert] = @attendance.errors.messages.values.flatten.first
    end
    redirect_to event_path(params[:id])
  end

  def destroy
    current_user.attendances.find_by(event_id: params[:id]).destroy
    flash[:notice] = "You are no longer attending this event."
    redirect_to event_path
  end
end
