require "test_helper"

describe DriversController do

  describe "index" do
    it "responds with success when there's more than one driver" do
      # Arrange
      Driver.create(name: "Sally Jones", vin: "123456789")
      Driver.create(name: "Bob Jones", vin: "987654321")

      # Act
      get drivers_path

      # Assert
      must_respond_with :success
    end

    it "responds with success when there at least one driver" do
      # Arrange
      Driver.create(name: "Sally Jones", vin: "123456789")

      # Act
      get drivers_path

      # Assert
      must_respond_with :success
    end

    it "still responds with success when there are no drivers saved" do
      # Arrange
      # zero drivers saved

      # Act
      get drivers_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    let (:sample_driver) {
      Driver.create(name: "Tom Jones", vin: "whatsnewpussycat")
    }

    it "responds with success for an existing valid driver id" do
      # Act
      get driver_path(sample_driver.id)
      
      # Assert
      must_respond_with :success
    end

    it "responds with 404 error for an invalid driver id" do
      # Act
      get driver_path(-1)
      
      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      # Act
      get new_driver_path
      
      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirects" do
      # Arrange
      driver_hash = {
        driver: {
          name: "New Driver",
          vin: "existing_driver_vin"
        }
      }
      
      # Act-Assert
      expect {
        post drivers_path, params: driver_hash
      }.must_differ "Driver.count", 1
      
      new_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(new_driver.available).must_equal true
      
      # Assert redirect
      must_respond_with :redirect
      must_redirect_to drivers_path
    end

    it "does not create a driver if no name is given, and re-renders page successfuly" do
      # Arrange
      invalid_driver_hash = {
        driver: {
          name: "",
          vin: "existing_driver_vin"
        }
      }
      
      # Act-Assert
      expect {
        post drivers_path, params: invalid_driver_hash
      }.wont_change "Driver.count"
      
      new_driver = Driver.find_by(name: invalid_driver_hash[:driver][:name])
      expect(new_driver).must_be_nil
      
      # Assert re-render
      must_respond_with :success
    end

    it "does not create a driver if no vin is given, and re-renders page successfuly" do
      # Arrange
      invalid_driver_hash = {
        driver: {
          name: "George Jones",
          vin: ""
        }
      }
      
      # Act-Assert
      expect {
        post drivers_path, params: invalid_driver_hash
      }.wont_change "Driver.count"
      
      new_driver = Driver.find_by(name: invalid_driver_hash[:driver][:name])
      expect(new_driver).must_be_nil
      
      # Assert re-render
      must_respond_with :success
    end

    it "does not create a driver if neither name or vin is given, and re-renders page successfuly" do
      # Arrange
      invalid_driver_hash = {
        driver: {
          name: "",
          vin: ""
        }
      }
      
      # Act-Assert
      expect {
        post drivers_path, params: invalid_driver_hash
      }.wont_change "Driver.count"
      
      new_driver = Driver.find_by(name: invalid_driver_hash[:driver][:name])
      expect(new_driver).must_be_nil
      
      # Assert re-render
      must_respond_with :success
    end
  end
  
  describe "edit" do
    let (:sample_driver) {
      Driver.create(name: "Tom Jones", vin: "whatsnewpussycat")
    }

    it "responds with success when getting the edit page for an existing, valid driver" do
      # Act
      get edit_driver_path(sample_driver.id)
      
      # Assert
      must_respond_with :success
    end

    it "responds with 404 error when getting the edit page for a non-existing driver" do
      # Act
      get edit_driver_path(-1)
      
      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    before do 
      Driver.create(name: "Tom Jones", vin: "whatsnewpussycat")
    end 

    let(:driver_hash){
      {
        driver: {
          name: "Tommy Jones",
          vin: "woahwoahwoahwoah"
        },
      }
    }

    it "can update an existing driver with valid information accurately, and redirects" do
      # Arrange
      existing_driver = Driver.first

      # Act-Assert
      expect {
        patch driver_path(existing_driver.id), params: driver_hash
      }.wont_change "Driver.count"
      
      # app should take the user back to the driver's show page after the driver is updated
      must_respond_with :redirect
      must_redirect_to driver_path(existing_driver.id)

      # update local variable to reflect values in DB
      existing_driver.reload 

      # values do change
      expect(existing_driver.name).must_equal driver_hash[:driver][:name]
      expect(existing_driver.vin).must_equal driver_hash[:driver][:vin]
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      # Act
      expect {
        patch driver_path(-1), params: driver_hash
      }.wont_change "Driver.count"
  
      # Assert
      must_respond_with :not_found
    end

    it "does not update driver if the form data is missing a name, and re-renders page successfuly" do
      # Arrange
      invalid_driver_hash = {
        driver: {
          name: "",
          vin: "woahwoahwoahwoah"
        }
      }
    
      existing_driver = Driver.first

      # Act-Assert
      expect {
        patch driver_path(existing_driver.id), params: invalid_driver_hash
      }.wont_change "Driver.count"
      
      new_driver = Driver.find_by(name: invalid_driver_hash[:driver][:name])
      expect(new_driver).must_be_nil
      
      # Assert re-render
      must_respond_with :success
    end

    it "does not update driver if the form data is missing a vin number, and re-renders page successfuly" do
      # Arrange
      invalid_driver_hash = {
        driver: {
          name: "Tommy Jones",
          vin: ""
        }
      }
    
      existing_driver = Driver.first

      # Act-Assert
      expect {
        patch driver_path(existing_driver.id), params: invalid_driver_hash
      }.wont_change "Driver.count"
      
      new_driver = Driver.find_by(name: invalid_driver_hash[:driver][:name])
      expect(new_driver).must_be_nil
      
      # Assert re-render
      must_respond_with :success
    end

    it "does not update driver if the form data is missing a name and number, and re-renders page successfuly" do
      # Arrange
      invalid_driver_hash = {
        driver: {
          name: "",
          vin: ""
        }
      }
    
      existing_driver = Driver.first

      # Act-Assert
      expect {
        patch driver_path(existing_driver.id), params: invalid_driver_hash
      }.wont_change "Driver.count"
      
      new_driver = Driver.find_by(name: invalid_driver_hash[:driver][:name])
      expect(new_driver).must_be_nil
      
      # Assert re-render
      must_respond_with :success
    end
  end

  describe "destroy" do
    before do 
      Driver.create(name: "Tom Jones", vin: "whatsnewpussycat")
    end 

    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      existing_driver = Driver.first

      # Act-Assert
      # task database should go down by one
      expect {
        delete driver_path(existing_driver.id)
      }.must_change "Driver.count", -1
      
      # app should refresh home page once a task has been deleted
      must_respond_with :redirect
      must_redirect_to drivers_path
    end

    it "does not change the db when the driver does not exist, then responds with 404 error" do
      # Act
      expect {
        delete driver_path(-1)
      }.wont_change "Driver.count"
  
      # Assert 
      must_respond_with :not_found
    end
  end
end