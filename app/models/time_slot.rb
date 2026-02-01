
class TimeSlot < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :day, presence: true
    validates :day, uniqueness: { scope: [:start_time, :end_time], message: "test message" }
  validate :end_time_after_start_time

  def display_time
    "#{start_time.strftime('%I:%M %p')} - #{end_time.strftime('%I:%M %p')}"
  end

  def display_day_time
    "#{day}: #{display_time}"
  end

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
