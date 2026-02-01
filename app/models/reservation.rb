class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :table
  belongs_to :time_slot

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  validates :date, presence: true
  validates :party_size, presence: true, numericality: { greater_than: 0 }
  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  validates :contact_email, presence: true

  validate :reservation_at_least_2_hours_ahead, on: :create
  validate :party_size_within_table_capacity

  private

  def reservation_at_least_2_hours_ahead
    return unless date && time_slot

    reservation_datetime = DateTime.new(
      date.year, date.month, date.day,
      time_slot.start_time.hour, time_slot.start_time.min
    )

    if reservation_datetime < 2.hours.from_now
      errors.add(:base, "Reservations must be made at least 2 hours in advance")
    end
  end

  def party_size_within_table_capacity
    return unless table && party_size

    if party_size > table.capacity
      errors.add(:party_size, "exceeds table capacity of #{table.capacity}")
    end
  end
end
