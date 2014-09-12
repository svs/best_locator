class Api::V1::BusStopsController < Api::V1::BaseController

  def index
    bus_stops = Stop.search_by(params)
    render  json: bus_stops.as_json
  end

  def show
    slug = params[:id]
    @bus_stop = Stop.find_by_slug(slug) || Stop.find(params[:id])
    render json: @bus_stop.routes
  end

end
