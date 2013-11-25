class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :name
      t.float :lat
      t.float :lon
      t.string :code
      t.string :official_name
      t.string :display_name
      t.string :url
      t.json :routes
      t.string :slug
      t.timestamps
    end
  end
end
