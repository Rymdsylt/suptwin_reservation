
class TimeSlot < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :day, presence: true

  def display_time
    "#{start_time.strftime('%I:%M %p')} - #{end_time.strftime('%I:%M %p')}"
  end

  def display_day_time
    "#{day}: #{display_time}"
  end
end
