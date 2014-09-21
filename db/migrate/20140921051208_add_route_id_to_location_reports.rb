class AddRouteIdToLocationReports < ActiveRecord::Migration
  def change
    add_column :location_reports,:route_id, :integer
  end
end
