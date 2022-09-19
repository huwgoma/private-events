class AttendancesController < ApplicationController
  def create
    @attendance = current_user.attendances.build(event_id: params[:id])

    if @attendance.save
      # success flash
    else
      # error flash - depends on why it failed?
    end
    redirect_to event_path(params[:id])
  end
end
