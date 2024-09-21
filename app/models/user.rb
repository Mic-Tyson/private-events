class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events, inverse_of: :creator, foreign_key: :user_id
  has_many :events_users
  has_many :event_rsvps, through: :events_users, source: :event
end
