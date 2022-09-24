class InvitesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @invitable_users = User.invitable_to(@event)
  end

  def create

  end
end
