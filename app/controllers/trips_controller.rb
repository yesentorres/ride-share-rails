class TripsController < ApplicationController

  def index
  end 

  def show
    trip_id = params[:id].to_i 
    @trip = Trip.find_by(id: trip_id) 

    if @trip.nil?
      redirect_to root_path 
    end
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
  end

  def create
    @trip = Trip.new(
      id: params[:trip][:id],
      driver_id: params[:trip][:driver_id],
      passenger_id: params[:trip][:passenger_id],
      date: params[:trip][:date],
      rating: params[:trip][:rating],
      cost: params[:trip][:cost]
      )
    if @trip.save
      redirect_to @trip
    else
      render :new
    end
  end
end
