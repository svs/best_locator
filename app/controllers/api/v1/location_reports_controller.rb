class Api::V1::LocationReportsController < Api::V1::BaseController


  def create
    @trip = Trip.find(params[:location_report][:trip_id])
    raise ActiveRecord::RecordNotFound unless @trip
    raise NotAuthorised unless @trip.user == current_user
    @lr = LocationReport.create(location_report_params)
    render json: @lr.to_json
  end

  private

  def location_report_params
    params.require("location_report").permit("trip_id","lat","lon","heading","accuracy","speed")
  end

end
