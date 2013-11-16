class Api::V1::BusStopsController < Api::V1::BaseController

  def index
    lat = params[:center_lat].to_f
    lon = params[:center_lon].to_f
    lat_lon_params = params.select{|k,v| ["center_lat", "center_lon"].include?(k) && !v.nil?}
    bus_stops = JSON.load(RestClient.get("http://chalobest.in/1.0/stops_near/", params: lat_lon_params))["features"]
    bus_stops = bus_stops.sort do |bs|
      bs_lat = bs["geometry"]["coordinates"][0]
      bs_lon = bs["geometry"]["coordinates"][1]
      -((bs_lat - lat).abs + (bs_lon - lon).abs)
    end
    render  json: bus_stops.as_json
  end

  def show
    slug = params[:id]
    @bus_stop = JSON.load(RestClient.get("http://chalobest.in/1.0/stop/#{slug}"))
    render json: @bus_stop
  end

end
