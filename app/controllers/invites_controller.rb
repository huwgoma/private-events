class InvitesController < ApplicationController
  before_action :authenticate_host_ownership, only: [:inviter_index, :create, :revoke]
  before_action :authenticate_invitee, only: [:invitee_index, :accept, :decline]

  # Only allow if the current user is the host of the event
  def inviter_index
    @event = Event.find(params[:event_id])
    @invite = Invite.new
    @invitable_users = User.invitable_to(@event)
    @invitees = @event.invitees
  end

  # Only allow if the current user is the host of the event
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

  # Only allow if the current user is the host of the event
  def revoke
    result = InvitesDestroyer.call(invite_params)
    unless result.delete_count.zero?
      flash[:notice] = "#{"Invite".pluralize(result.delete_count)} successfully cancelled."
    end
    redirect_to event_invites_path
  end

  # Only allow if the current user matches the user
  def invitee_index
    user = User.find(params[:user_id])
    @received_invites = user.received_invites.includes(:event, :inviter)
  end

  # Only allow if the current user's id matches the invitee id  
  def accept
    InvitesDestroyer.call(params)
    AttendancesCreator.call(attendee_id: params[:user_id], event_id: params[:event_id])
    flash[:notice] = "You are now attending this event."
    redirect_to user_invites_path
  end

  # Only allow if the current user's id matches the invitee id  
  def decline
    InvitesDestroyer.call(params)
    flash[:notice] = "Invite declined."
    redirect_to user_invites_path
  end

  private

  def invite_params
    params.require(:invite).permit(user_ids:[]).merge(inviter_id: current_user.id, event_id: params[:event_id])
  end

  def authenticate_host_ownership
    current_user.hosted_events.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "You do not have permission to manage invites for this event!"
    redirect_to event_path(params[:event_id])
  end

  def authenticate_invitee
    unless current_user == User.find(params[:user_id])
      flash[:alert] = "You do not have permission to view this user's invites!"
      redirect_to user_path(params[:user_id])
    end
  end
end
