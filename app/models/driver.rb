class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true

  def total_revenue 
    # handle case if there's no trips 
    if self.trips.length == 0 
      return 0.0
    end 
    
    # calculate total revenue
    total_rev = 0.0 
    self.trips.each do |trip|
      if trip.cost != nil
        total_rev += trip.cost
      end
    end
    
    # handle case if total revenue is less than 1.65 (i.e. make sure there's no negative values)
    if total_rev < 1.65
      return 0.0 
    else 
      return ((total_rev - 1.65)*0.8).round(2) # subtract fee and make sure driver gets their 80% cut
    end
  end

  def average_rating
    trip_ratings = 0 
    self.trips.each do |trip|
      if trip.rating != nil
        trip_ratings += trip.rating 
      end
    end
    
    if trip_ratings > 0
      return (trip_ratings / trips.length).round(2) 
    else 
      return 0
    end
  end
end
