class Passenger < ApplicationRecord
  has_many :trips
  
  validates :name, presence: true
  validates :phone, presence: true

  def trips_sum
    total = self.trips.sum(:cost)
    return total
  end
end
