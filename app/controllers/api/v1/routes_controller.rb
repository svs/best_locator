class Api::V1::RoutesController < ApplicationController

  def index
    if params[:q]
      route = routes.select{|b| b["display_name"] == CGI.unescape(params[:q])}[0]
      render json: route
    elsif params[:lat] && params[:lon]
      routes = Route.near(params[:lat], params[:lon], 2000)
      render json: routes
    else
      routes = Route.all(offset: params[:offset], limit: params[:limit])
      render json: routes
    end

  end

  def show
    route = Route.find(params[:id])
    render json: route.attributes.merge(:stops => route.stops.uniq.map(&:attributes))
  end

end
