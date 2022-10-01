class InvitesController < ApplicationController
  #before_action :authenticate_host_ownership, only: [:inviter_index, :create, :revoke]
  #before_action :authenticate_invitee, only: [:invitee_index, :accept, :decline]
  before_action :authenticate_user!, only: [:index, :accept, :decline]

  # Invitee Actions - Permit only if the current user is logged in
  def index
    @received_invites = current_user.received_invites.includes(:event, :inviter)
  end
  
  def accept
    invite = Invite.find(params[:id])
    AttendancesCreator.call(attendee_id: current_user.id, event_id: invite.event_id)
    InvitesDestroyer.call(params[:id])
    flash[:notice] = "You are now attending this event."
    redirect_to invites_path
  end

  def decline
    InvitesDestroyer.call(params[:id])
    flash[:notice] = "Invite declined."
    redirect_to invites_path
  end

  # Inviter Actions - Permit only if the current user is the host of the event
  def manage
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

  # def authenticate_invitee
  #   unless current_user == User.find(params[:user_id])
  #     flash[:alert] = "You do not have permission to view this user's invites!"
  #     redirect_to user_path(params[:user_id])
  #   end
  # end
end
