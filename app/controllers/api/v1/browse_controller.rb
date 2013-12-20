class Api::V1::BrowseController < ApplicationController

  def map_squares
    render json: MapSquare.all
  end

  def areas
    render json: MapSquare.find(params[:map_square_id]).areas(sort: params[:sort])
  end

  def bus_stops
    render json: Stop.search_by(params).to_a.uniq
  end

  def route
    routes = Route.joins(:stops).where('stops.display_name' => params[:start_bus_stop]) &
    Route.joins(:stops).where('stops.display_name' => params[:end_bus_stop])
    render json: routes.map{|r| r.attributes.merge(:next_bus_time => nil, :next_bus_fullness => nil)}
  end

end
