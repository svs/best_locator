class Api::V1::RoutesController < ApplicationController

  def index
    routes = Route.all(offset: params[:offset], limit: params[:limit])
    if params[:q]
      route = routes.select{|b| b["display_name"] == CGI.unescape(params[:q])}[0]
      render json: route
    else
      render json: routes
    end

  end

  def show
    route = Route.find(params[:id])
    render json: route.attributes.merge(:stops => route.stops.uniq.map(&:attributes))
  end

end
