class AddBusIdToLocationReports < ActiveRecord::Migration
  def change
    add_column :location_reports, :bus_id, :string
  end
end
