class Passenger < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true
end
