class AttendancesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @attendance = current_user.attendances.build(event_id: params[:id])
    if @attendance.save
      flash[:notice] = "You are now attending this event."
    else
      flash[:alert] = @attendance.errors
    end
    redirect_to event_path(params[:id])
  end
end
