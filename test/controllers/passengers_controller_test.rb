require "test_helper"

# TODO: update trip tests

describe PassengersController do

  before do
    Passenger.create(name: "Gloria Anzaldua", phone_num: "1-512-448-0839")
  end

  describe "index" do
    it "retrieves index" do
      get "/passengers"
      must_respond_with :success 
    end
  end 

  describe "show" do
    let (:sample_passenger) {
      Passenger.create(name: "Kurt Vile", phone_num: "3452341111")
    }

    it "responds with success for an existing valid passenger id" do
      get passenger_path(sample_passenger.id)
      must_respond_with :success
    end

    it "redirects to root_path if an passenger is nil" do
      get "/passengers/1250"
      must_redirect_to root_path
    end
  end 

  describe "update" do
    before do
      Passenger.create(name: "Gloria Anzaldua", phone_num: "1-512-448-0839")
    end
    it "returns an error if passenger is nil" do
      get edit_passenger_path(-1)
      must_respond_with :not_found
    end

    it "does not update passenger if the form data is missing a name, and re-renders page successfully" do 
      invalid_passenger_hash = {
        driver: {
          name: "",
          phone_num: "ScooooobyDooobyDoo"
        }
      }
    
      valid_passenger = Passenger.first

      expect {
        patch passenger_path(valid_passenger.id), params: invalid_passenger_hash
      }.wont_change "Passenger.count"
      
      new_passenger = Passenger.find_by(name: invalid_passenger_hash[:driver][:name])
      expect(new_passenger).must_be_nil
      
      must_respond_with :success
    end
  end 


  describe "edit" do
    let (:sample_passenger) {
      Passenger.create(name: "Misty Day", phone_num: "39DHAN384Y763HGDN")
    }

    it "can retrieve the edit path for a valid passenger" do
      get edit_passenger_path(sample_passenger.id)
      must_respond_with :success
    end

    it "responds with 404 error when getting the edit page for a non-existing passenger" do
      get edit_passenger_path(-1)
      must_respond_with :not_found
    end
  end 

  describe "destroy" do
    it "removes the passenger from database, then redirects" do
      valid_passenger = Passenger.last
      expect { delete passenger_path(valid_passenger.id)}.must_change "Passenger.count", -1

      must_respond_with :redirect
      must_redirect_to passengers_path
    end

    it "does not change the database when the driver does not exist, then responds with 404 error" do
      expect {delete passenger_path(-1)}.wont_change "Passenger.count"

      must_respond_with :not_found
  end 

  describe "new" do
    it "responds with success" do
      get new_passenger_path
      must_respond_with :success 
    end
  end 

  describe "create" do
    it "can create a new passenger with valid information accurately" do
      passenger_hash = {
        driver: {
          name: "Gloria Steinem",
          phone_num: "2028645789"
        }
      }
      
      expect {
        post passengers_path, params: passenger_hash
      }.must_differ "Passenger.count", 1
    end

    it "does not create a passenger if no name is given, and re-renders page successfuly" do
      passenger_hash = {
        driver: {
          name: "",
          phone_num: "304.392.4313"
        }
      }
      
      expect {
        post passengers_path, params: passenger_hash
      }.wont_change "Passenger.count"
    
      new_passenger = Passenger.find_by(name: passenger_hash[:name][:phone])
      expect(new_passenger).must_be_nil
      
      must_respond_with :success
    end
  end 
end
end