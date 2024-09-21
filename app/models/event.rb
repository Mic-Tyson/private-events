class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :events_users
  has_many :attendees, through: :events_users, source: :user

  scope :upcoming, ->(date = Date.today) { where('date >= ?', date) }
  scope :expired, ->(date = Date.today) { where('date < ?', date) }

  def expired?
    date < Date.today
  end
end
