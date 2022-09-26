class InvitesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @invite = current_user.sent_invites.new
    #@invitable_users = User.invitable_to(@event)
    @invitable_users = User.all
    @invites = Invite.includes(:invitee).where(event: @event)
  end

  def create
    invites = InvitesCreator.new(invite_params).execute

    if invites.success?
      flash[:notice] = "Invites successfully sent."
    else 
      flash[:alert] = "Invites could not be sent."
    end
    redirect_to event_invites_path
  end

  private

  def invite_params
    params.require(:invite).permit(user_ids:[]).merge(inviter_id: current_user.id, event_id: params[:event_id])
  end
end
