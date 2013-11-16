class Api::V1::TripsController < Api::V1::BaseController

  before_filter :authenticate_user_from_token

  def index
    current_user.trips
  end



end
