class RouteStops < ActiveRecord::Migration
  def change
    create_join_table :routes, :stops do |t|
      t.index :route_id
      t.index :stop_id
    end
  end
end
