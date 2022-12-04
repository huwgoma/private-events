class InvitesDestroyer
  def initialize(invite_ids)
    @invite_ids = invite_ids
  end

  def self.call(*args, &block)
    new(*args, &block).execute
  end
  
  def execute
    invites = Invite.where(id: @invite_ids).destroy_all
    OpenStruct.new(delete_count: invites.count)
  end
end