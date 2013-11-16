class TripsController < ApplicationController

  before_filter :authenticate_user!

  def new
    render
  end

end
