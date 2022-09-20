class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :time_zone, presence: true

  has_many :hosted_events, class_name: "Event", foreign_key: "host_id"
  has_many :attendances, foreign_key: :attendee_id
  has_many :attending_events, through: :attendances, source: :event
end
