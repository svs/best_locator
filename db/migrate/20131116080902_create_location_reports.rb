class CreateLocationReports < ActiveRecord::Migration
  def change
    create_table :location_reports do |t|
      t.integer :trip_id
      t.float :lat
      t.float :lon
      t.datetime :reported_at

      t.timestamps
    end
  end
end
