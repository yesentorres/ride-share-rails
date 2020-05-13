class Trip < ApplicationRecord
  validates :date, presence: true
  validates :cost, presence: true

  def self.appoint_driver
    puts Driver.all.count
    @driver = Driver.all.select {|driver| driver.available }.shuffle.first
    @driver.available = false
    @driver.save
    puts Driver.all.select {|driver| driver.available }.count
    return @driver
  end
end
