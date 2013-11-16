class Api::V1::BusStopsController < ApplicationController

  def index
    lat_lon_params = params.select{|k,v| ["center_lat", "center_lon"].include?(k) && !v.nil?}
    r = RestClient.get("http://chalobest.in/1.0/stops_near/", params: lat_lon_params)
    respond_to do |format|
      format.json { render json: r }
    end
  end

end
