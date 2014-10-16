class AddBusStopIdToLocationReports < ActiveRecord::Migration
  def change
    add_column :location_reports, :stop_id, :integer
  end
end
