class InvitesController < ApplicationController
  def inviter_index
    @event = Event.find(params[:event_id])
    @invite = Invite.new
    @invitable_users = User.invitable_to(@event)
    @invitees = @event.invitees
  end

  def create
    invites = InvitesCreator.call(invite_params)

    if invites.successes.present?
      flash[:notice] = "#{invites.successes.count} #{"invite".pluralize(invites.successes.count)} successfully sent."
    end
    if invites.failures.present?
      flash[:alert] = "The following #{"user".pluralize(invites.failures.count)} could not be invited:"
      # Array of usernames that could not be invited
      flash[:failed_invites] = User.find(invites.failures.map(&:invitee_id)).pluck(:name)
    end
    redirect_to event_invites_path
  end

  def destroy
    result = InvitesDestroyer.call(invite_params)
    unless result.delete_count.zero?
      flash[:notice] = "#{"Invite".pluralize(result.delete_count)} successfully cancelled."
    end
    redirect_to event_invites_path
  end

  def invitee_index
    user = User.find(params[:user_id])
    @received_invites = user.received_invites.includes(:event, :inviter)
  end

  private

  def invite_params
    params.require(:invite).permit(user_ids:[]).merge(inviter_id: current_user.id, event_id: params[:event_id])
  end
end
