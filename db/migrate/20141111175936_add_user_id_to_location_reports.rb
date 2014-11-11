class AddUserIdToLocationReports < ActiveRecord::Migration
  def change
    add_column :location_reports, :user_id, :integer
  end
end
