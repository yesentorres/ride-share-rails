class Passenger < ApplicationRecord
  has_many :trips
  
  validates :name, presence: true
  validates :phone_num, presence: true

  def trips_total_cost
    # handle case if there's no trips 
    if self.trips.length == 0 
      return 0.0
    end 
    
    # calculate total revenue
    total_cost = 0.0 
    self.trips.each do |trip|
      total_cost += trip.cost
    end

    return total_cost
  end
end
