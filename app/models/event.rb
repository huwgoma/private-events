class Event < ApplicationRecord
  validates :name, :datetime, :location, presence: true 
  belongs_to :host, class_name: "User"
end
