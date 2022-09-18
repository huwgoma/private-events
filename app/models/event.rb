class Event < ApplicationRecord
  validates :name, :datetime_of, :location, presence: true 
  belongs_to :host, class_name: "User"
end
