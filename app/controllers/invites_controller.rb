class InvitesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    #@invitable_users = User.invitable_to(@event)
    @invitable_users = User.all
    @invites = Invite.includes(:invitee).where(event: @event)
  end

  def create

  end
end
