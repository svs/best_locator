class Api::V1::BusStopsController < Api::V1::BaseController

  def index
    lat = params[:center_lat].to_f
    lon = params[:center_lon].to_f
    bus_stops = Stop.order("abs(lat - #{lat}) + abs(lon - #{lon})").limit(10)
    render  json: bus_stops.as_json
  end

  def show
    slug = params[:id]
    @bus_stop = Stop.find_by_slug(slug)
    render json: @bus_stop.routes
  end

end
