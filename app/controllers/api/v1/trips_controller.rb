class Api::V1::TripsController < Api::V1::BaseController

  before_filter :authenticate_user_from_token!, except: [:live]
  protect_from_forgery except: [:create, :stop, :update]

  def index

    @trips = observed_user.trips
    render json: @trips.to_json
  end

  def show
    @trip = observed_user.trips.where(:id => params[:id]).first
    raise ActiveRecord::RecordNotFound unless @trip
    render json: @trip.to_json
  end


  def create
    @trip = Trip.create(trip_params)
    if @trip.persisted?
      @trip.start!
      render json: @trip.as_json
    else
      render json: @trip.errors.as_json, :status => 422
    end
  end


  def update
    @trip = Trip.find(params[:id])
    raise NotAuthorized unless @trip.user == current_user
    @trip.update_attributes(trip_params)
    render json: @trip
  end

  def stop
    @trip = Trip.find(params[:id])
    raise NotAuthorized unless @trip.user == current_user
    @trip.stop!
    render json: @trip
  end

  def live
    if current_user
      @trips = current_user.trips.live
      render json: @trips
    else
      render json: []
    end
  end

  private

  def trip_params
    ps = params.require("trip").permit("bus_number", "start_stop_id", "start_stop_code","start_stop_name","end_stop_id","end_stop_code","end_stop_name", "fullness", "license_number")
    ps["user_id"] = current_user.id
    ps
  end

end
