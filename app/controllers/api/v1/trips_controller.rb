class Api::V1::TripsController < Api::V1::BaseController

  before_filter :authenticate_user_from_token!

  def index
    @trips = current_user.trips
    render json: @trips.to_json
  end

  def create
    @trip = Trip.create(trip_params)
    respond_to do |format|
      format.json do
        if @trip.persisted?
          @trip.start!
          render json: @trip.as_json
        else
          render json: @trip.errors.as_json, :status => 422
        end
      end
    end
  end


  def stop
    @trip = Trip.find(params[:id])
    @trip.stop!
    respond_to do |format|
      format.json { render json: @trip }
    end
  end

  private

  def trip_params
    ps = params.permit("trip")
    ps["user_id"] = current_user.id
    ps
  end

end
