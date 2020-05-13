class TripsController < ApplicationController

  def index
    if params[:passenger_id].nil?
      @trips = Trip.all
    else
      @passenger = Passenger.find_by(id: params[:passenger_id])
      @trips = Trip.where(passenger_id: params[:passenger_id])
    end
  end 

  def show
    trip_id = params[:id].to_i 
    @trip = Trip.find_by(id: trip_id) 

    if @trip.nil?
      redirect_to root_path 
    end
    
    @passenger = Passenger.find_by(id: @trip.passenger_id)
    @driver = Driver.find_by(id: @trip.driver_id)
    # ^ To access details in view
  end

  def update
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
    elsif @trip.update(
      id: params[:trip][:id],
      driver_id: params[:trip][:driver_id],
      passenger_id: params[:trip][:passenger_id],
      date: params[:trip][:date],
      rating: params[:trip][:rating],
      cost: params[:trip][:cost]
    )
      redirect_to trip_path
    else
      render :edit
    end
  end

  def edit 
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
    end
  end

  def destroy
  end 

  def new
    @trip = Trip.new
    if params[:passenger_id].nil?
    else
      @passenger = Passenger.find_by(id: params[:passenger_id])
    end
    puts 
  end

  # def create
  #   @trip = Trip.new(
  #     id: params[:trip][:id],
  #     driver_id: params[:trip][:driver_id],
  #     passenger_id: params[:trip][:passenger_id],
  #     date: params[:trip][:date],
  #     rating: params[:trip][:rating],
  #     cost: params[:trip][:cost]
  #     )
  #   if @trip.save
  #     redirect_to @trip
  #   else
  #     render :new
  #   end
  # end

  def create
    driver = Trip.appoint_driver
    date = Date.today
    @trip = Trip.new(
      driver_id: driver.id,
      passenger_id: params[:passenger_id], 
      date: date,
      rating: nil, 
      cost: rand(12..112).to_f, 
    )
    if @trip.save
      driver = "false"
      driver.save
      redirect_to passenger_path(params[:passenger_id])
      return
    else
      render :new, status: :bad_request 
      return
    end
  end
  
end
