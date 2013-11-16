class Api::V1::BusStopsController < Api::V1::BaseController

  def index
    lat_lon_params = params.select{|k,v| ["center_lat", "center_lon"].include?(k) && !v.nil?}
    r = RestClient.get("http://chalobest.in/1.0/stops_near/", params: lat_lon_params)
    render  json: r.as_json
  end

end
