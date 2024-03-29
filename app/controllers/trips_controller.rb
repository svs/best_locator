class TripsController < ApplicationController

  before_filter :authenticate_user!, except: [:new]

  def new
    render
  end

  def show
    @trip = Trip.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @trip.user == current_user
  end

end
