class InvitesDestroyer
  def initialize(invite_ids)
    # If given an Array - Strip the blank values; otherwise, just take the value as-is
    @invite_ids = invite_ids.respond_to?(:reject) ? invite_ids.reject(&:blank?) : invite_ids
  end

  def self.call(*args, &block)
    new(*args, &block).execute
  end
  
  def execute
    invites = Invite.where(id: @invite_ids).destroy_all
    OpenStruct.new(delete_count: invites.count)
  end
end