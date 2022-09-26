class InvitesCreator
  def initialize(params)
    @event_id = params[:event_id]
    @inviter_id = params[:inviter_id]
    @user_ids = params[:user_ids].reject(&:blank?)
    @invites = { success: [], failure: [] }
  end

  def execute
    @user_ids.each do |uid|
      invite = Invite.new(event_id: @event_id, inviter_id: @inviter_id, invitee_id: uid)
      if invite.save 
        @invites[:success] << invite
      else
        @invites[:failure] << invite
      end
    end
    OpenStruct.new(successes: @invites[:success], failures: @invites[:failure])
  end
end