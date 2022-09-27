class InvitesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @invite = Invite.new
    #@invitable_users = User.invitable_to(@event)
    @invitable_users = User.all
    @invites = Invite.includes(:invitee).where(event: @event)
  end

  def create
    invites = InvitesCreator.call(invite_params)

    if invites.successes.present?
      flash[:notice] = "#{invites.successes.count} #{"invite".pluralize(invites.successes.count)} successfully sent."
    end
    if invites.failures.present?
      flash[:alert] = "The following #{"user".pluralize(invites.failures.count)} could not be invited:"
      flash[:invite_failures] = User.where(id: invites.failures.map(&:invitee_id)).pluck(:name)
    end
    redirect_to event_invites_path
  end

  private

  def invite_params
    params.require(:invite).permit(user_ids:[]).merge(inviter_id: current_user.id, event_id: params[:event_id])
  end
end
