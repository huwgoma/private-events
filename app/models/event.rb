class Event < ApplicationRecord
  include Attendable

  validates :name, :datetime_of, :location, presence: true 
  validates :datetime_of, comparison: { greater_than: DateTime.current, message: "must be in the future!" }
  
  belongs_to :host, class_name: "User"
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances

  has_many :invites, dependent: :destroy
  has_many :invitees, through: :invites

  attr_accessor :current_user

  # Past/Future Events
  scope :past, -> { where("datetime_of < ?", DateTime.now) }
  scope :future, -> { where("datetime_of > ?", DateTime.now) }

  # Format Event Date/Time
  def date_of
    datetime_of.strftime("%B %d, %Y")
  end

  def time_of
    datetime_of.strftime("%l:%M %p")
  end
end
