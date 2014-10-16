class Api::V1::LocationReportsController < Api::V1::BaseController

  before_filter :authenticate_user_from_token!
  protect_from_forgery except: [:create]

  def create
    @route = Route.find(params[:location_report][:route_id])
    raise ActiveRecord::RecordNotFound unless @route
    @lr = LocationReport.create(location_report_params)
    render json: @lr.to_json
  end

  private

  def location_report_params
    params.require("location_report").permit("route_id","lat","lon","heading","accuracy","speed", "bus_id")
  end

end
