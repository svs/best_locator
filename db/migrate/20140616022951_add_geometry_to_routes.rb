class AddGeometryToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :geometry, :geometry
  end
end
