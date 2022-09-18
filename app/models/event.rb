class Event < ApplicationRecord
  validates :name, :date_of, :time_of, :location, presence: true 
  belongs_to :host, class_name: "User"
end
