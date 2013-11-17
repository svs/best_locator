class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :user_id
      t.string :bus_number

      t.integer :start_stop_id
      t.string :start_stop_name
      t.integer :start_stop_code

      t.integer :end_stop_id
      t.string :end_stop_name
      t.integer :end_stop_code

      t.datetime :started_at
      t.datetime :ended_at
      t.string :status, :default => "new"
      t.timestamps
    end
  end
end
