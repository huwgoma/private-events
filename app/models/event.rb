class Event < ApplicationRecord
  validates :name, :datetime_of, :location, presence: true 
  
  belongs_to :host, class_name: "User"
  has_many :attendances
  has_many :attendees, through: :attendances, source: :attendee

  # Format Event Date/Times
  def format_date
    datetime_of.strftime("%B %d, %Y")
  end

  def format_time
    datetime_of.strftime("%l:%M %p")
  end

  def format_datetime
    "#{format_date} at #{format_time}"
  end
end
