class CreateArrivals < ActiveRecord::Migration
  def change
    create_table :arrivals do |t|
      t.integer :stop_id
      t.integer :route_id

      t.integer :heading
      t.integer :stops_away
      t.datetime :report_time
      t.integer :report_id
      t.timestamps
    end
  end
end
