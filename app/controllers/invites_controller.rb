class InvitesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @invite = current_user.sent_invites.new
    #@invitable_users = User.invitable_to(@event)
    @invitable_users = User.all
    @invites = Invite.includes(:invitee).where(event: @event)
  end

  def create
    @event = Event.find(invite_params[:event_id])
    InvitesCreator.new(invite_params).execute
  end

  private

  def invite_params
    params.require(:invite).permit(:event_id, user_ids:[]).merge(inviter_id: current_user.id)
  end
end
