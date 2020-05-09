class PassengersController < ApplicationController

  def index 
    @passengers = Passenger.all
  end 

  def show
    passenger_id = params[:id].to_i 
    @passenger = Passenger.find_by(id: passenger_id) 

    if @passenger.nil?
      redirect_to root_path 
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
    elsif @passenger.update(
      # id: params[:passenger][:id],
      name: params[:passenger][:name],
      phone: params[:passenger][:phone]
    )
      redirect_to passenger_path
    else
      render :edit
    end
  end

  def edit 
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
    end
  end

  def destroy
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
      return
    else
      @passenger.destroy
      redirect_to root_path
      return 
    end
  end 

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(
      id: params[:passenger][:id],
      name: params[:passenger][:name],
      phone: params[:passenger][:phone]
      )
    if @passenger.save
      redirect_to @passenger
    else
      render :new
    end
  end
end