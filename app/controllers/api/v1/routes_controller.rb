class Api::V1::RoutesController < ApplicationController

  def index
    if params[:q]
      route = routes.select{|b| b["display_name"] == CGI.unescape(params[:q])}[0]
      render json: route.attributes.except(:geometry) and return
    elsif params[:ids]
      routes = Route.find(params[:ids])
    elsif params[:lat] && params[:lon]
      routes = Route.near(params[:lat], params[:lon], 200)
    elsif params[:lat1] && params[:lon1] && params[:lat2] && params[:lon2]
      end_distance = (params[:lon1].to_f - params[:lon2].to_f).abs + (params[:lat1].to_f - params[:lat2].to_f).abs
      Rails.logger.info("#Routes distance = #{end_distance}")
      starting_routes = Route.near(params[:lat1], params[:lon1], 200)
      ending_routes = Route.near(params[:lat2], params[:lon2], [1000 * end_distance, 300].max)
      routes =  starting_routes & ending_routes
    else
      routes = Route.all(offset: params[:offset], limit: params[:limit], order: :display_name)
      render json: routes.map{|r| r.attributes.slice("id", "display_name")} and return
    end
    render json: routes.map{|r| r.attributes.except(:geometry)}
  end

  def show
    route = Route.find(params[:id])
    render json: route.attributes.merge(:stops => route.stops.uniq.map(&:attributes))
  end

end
