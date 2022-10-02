class InvitesCreator
  def initialize(params)
    @event_id = params[:event_id]
    @inviter_id = params[:inviter_id]
    @user_ids = params[:user_ids].reject(&:blank?)
    @result = { success: [], failure: [] }
  end

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def execute
    @user_ids.each do |uid|
      invite = Invite.new(event_id: @event_id, inviter_id: @inviter_id, invitee_id: uid)
      if invite.save 
        @result[:success] << invite
      else
        @result[:failure] << invite
      end
    end
    OpenStruct.new(successes: @result[:success], failures: @result[:failure], failed_users: User.find(@result[:failure].map(&:invitee_id)).pluck(:name))
  end
end