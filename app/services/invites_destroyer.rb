class InvitesDestroyer
  def initialize(params)
    @event_id = params[:event_id]
    @user_ids = params[:user_ids].reject(&:blank?)
  end

  def self.call(*args, &block)
    new(*args, &block).execute
  end
  
  def execute
    event = Event.find(@event_id)
    invites = event.invites.where(invitee_id: @user_ids).destroy_all
    OpenStruct.new(delete_count: invites.count)
  end
end