class Table < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
end
