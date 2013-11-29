class CreateMapSquares < ActiveRecord::Migration
  def change
    create_table :map_squares do |t|
      t.float :lat1
      t.float :lon1
      t.float :lat2
      t.float :lon2
      t.string :index
      t.string :name
      t.timestamps
    end
  end
end
