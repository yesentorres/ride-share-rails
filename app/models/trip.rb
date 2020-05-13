class Trip < ApplicationRecord
  validates :date, presence: true
  validates :cost, presence: true

  def self.appoint_driver
    @driver = Driver.all.select {|driver| driver.available == true }.shuffle.first
    @driver.available = false
    @driver.save
    return @driver
  end
end
