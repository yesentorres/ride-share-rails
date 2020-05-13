require "test_helper"

describe TripsController do
  
  let (:driver) {
    Driver.create name: "Captain Quint",
      vin: "398YEB947GH3452BH",
      available: true
  }

  let (:passenger) {
    Passenger.create name: "Matt Hooper",
      phone_num: "345.635.2129"
  }

  let (:trip) {
    Trip.create passenger_id: passenger.id,
      driver_id: driver.id,
      date: Date.today,
      rating: nil,
      cost: 12
  }
  
  describe "index" do
    it "returns a list of all trips in the database" do
      get "/trips"
      must_respond_with :success
    end 
  end

  describe "show" do 
    it "responds with success for an existing valid trip id" do
      get trip_path(passenger.id)
      must_respond_with :success
    end

    it "redirects to root_path if a trip is nil" do
      get "/trips/12500"
      must_redirect_to root_path
    end
  end

  describe "update" do
    it "returns an error if trip is nil" do
      get "/trip/1876"
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing valid trip id" do 
      get trip_path(trip.id)
      must_respond_with :success
    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists" do
      expect {
        delete trip_path(trip.id)
      }.must_change "Trip.count", -1
    end
  end

  describe "new" do
    it "responds with success" do
      get new_trip_path
      must_respond_with :success
    end
  end 

  describe "create" do 
    it "can create a new trip, then redirect" do 
      expect {post passenger_trips_path(passenger_id)}.must_differ "Trip.count", 1
      must_redirect_to trip_path(trip_id)
    end 
  end
end
