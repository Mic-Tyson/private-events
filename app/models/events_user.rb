class EventsUser < ApplicationRecord
  belongs_to :event
  belongs_to :user

  enum status: { invited: 0, confirmed: 1 }

  scope :invited, -> { where(status: :invited) }
  scope :confirmed, -> { where(status: :confirmed) }
end
