class Passenger < ApplicationRecord
  has_many :trips
  
  validates :name, presence: true
  validates :phone_num, presence: true

  def trips_sum
    total = self.trips.sum(:cost)
    return total
  end
end
