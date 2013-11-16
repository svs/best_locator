class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :user_id
      t.string :bus_number
      t.integer :start_stop_id
      t.integer :end_stop_id
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
