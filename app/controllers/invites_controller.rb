class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_host_ownership, only: [:manage, :create, :revoke]

  # Invitee Actions - Permit only if the current user is logged in
  def index
    @received_invites = current_user.received_invites.includes(:event, :inviter)
  end
  
  def accept
    invite = Invite.find(params[:id])
    attendance = AttendancesCreator.call(attendee_id: current_user.id, event_id: invite.event_id)
    InvitesDestroyer.call(params[:id])
    
    if attendance.success?
      flash[:notice] = "You are now attending this event."
    else
      flash[:alert] = attendance.errors.messages.values.flatten.first
    end 
    redirect_back(fallback_location: invites_path)
  end

  def decline
    InvitesDestroyer.call(params[:id])
    flash[:notice] = "Invite declined."
    redirect_back(fallback_location: invites_path)
  end

  # Inviter Actions - Permit only if the current (logged in) user is the host of the event
  def manage
    @event = Event.find(params[:event_id])
    @invite = Invite.new
    @invitable_users = User.invitable_to(@event)
    @invites = @event.invites.includes(:invitee)
  end

  def create
    invites = InvitesCreator.call(invite_params)

    if invites.successes.present?
      flash[:notice] = "#{invites.successes.count} #{"invite".pluralize(invites.successes.count)} successfully sent."
    end
    if invites.failures.present?
      flash[:alert] = "The following #{"user".pluralize(invites.failures.count)} could not be invited:"
      # Array of usernames that could not be invited
      flash[:failed_invites] = invites.failed_users
    end
    redirect_to event_invites_path
  end

  def revoke
    result = InvitesDestroyer.call(params[:invite_ids])
    unless result.delete_count.zero?
      flash[:notice] = "#{"Invite".pluralize(result.delete_count)} successfully cancelled."
    end
    redirect_to event_invites_path
  end

  private

  def invite_params
    params.require(:invite).permit(user_ids:[]).merge(inviter_id: current_user.id, event_id: params[:event_id])
  end

  def authenticate_host_ownership
    current_user.hosted_events.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "You do not have permission to #{action_name} invites for this event!"
    redirect_to event_path(params[:event_id])
  end
end
