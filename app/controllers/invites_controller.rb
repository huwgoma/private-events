class InvitesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @invitable_users = User.all
  end

  def create

  end
end
