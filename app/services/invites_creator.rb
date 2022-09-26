class InvitesCreator
  def initialize(params)
    @event_id = params[:event_id]
    @inviter_id = params[:inviter_id]
    @user_ids = params[:user_ids].reject(&:blank?)
  end

  def execute
    @user_ids.each do |uid|
      Invite.create!(event_id: @event_id, inviter_id: @inviter_id, invitee_id: uid)
    rescue ActiveRecord::RecordInvalid
      return OpenStruct.new(success?: false)
    end
    OpenStruct.new(success?: true)
  end
end