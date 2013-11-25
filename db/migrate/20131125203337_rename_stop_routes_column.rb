class RenameStopRoutesColumn < ActiveRecord::Migration
  def change
    rename_column :stops, :routes, :route_names
  end
end
