class Api::V1::RoutesController < ApplicationController

  def index
    routes = JSON.load(RestClient.get("http://chalobest.in/1.0/routes/", params: {:q => params[:q]}))
    route = routes.select{|b| b["display_name"] == CGI.unescape(params[:q])}[0]
    render json: route
  end

  def show
    route = JSON.load(RestClient.get("http://chalobest.in/1.0/route/#{params[:id]}"))["stops"]["features"]
    render json: route
  end

end