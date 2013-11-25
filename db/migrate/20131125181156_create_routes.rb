class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :code
      t.string :end_area
      t.string :start_stop
      t.string :start_area
      t.string :display_name
      t.string :url
      t.string :slug
      t.string :end_stop

      t.timestamps
    end
  end
end
