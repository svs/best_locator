class AddOrderToRoutesStops < ActiveRecord::Migration
  def change
    execute 'alter table routes_stops drop column id;'
    execute 'alter table routes_stops add column id serial;'
    execute "UPDATE routes_stops SET id = nextval(pg_get_serial_sequence('routes_stops','id'));"
    execute 'alter table routes_stops ADD PRIMARY KEY (id);'
    add_column :routes_stops, :order, :integer
  end
end
