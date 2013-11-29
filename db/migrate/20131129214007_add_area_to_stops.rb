class AddAreaToStops < ActiveRecord::Migration
  def change
    add_column :stops, :area, :string
  end
end
