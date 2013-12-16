class AddFullnessAndLicenseToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :fullness, :string
    add_column :trips, :license_number, :string
  end
end
