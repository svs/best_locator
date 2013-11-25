class Stop < ActiveRecord::Base

  has_and_belongs_to_many :routes

  def self.attrs_from_chalo_best(json)
    json["properties"].slice(*self.attribute_names).except("id").
      merge("lat" => json["geometry"]["coordinates"][1], "lon" => json["geometry"]["coordinates"][0]).tap do |attrs|
      attrs["routes"] = JSON.dump("ids" => attrs["routes"])
    end
  end

  def self.create_from_chalo_best(json, override = false)
    bus_stop_attrs = attrs_from_chalo_best(json)
    bs = Stop.where("slug" => bus_stop_attrs["slug"]).first_or_create(bus_stop_attrs).tap{|b|
      b.update_attributes(bus_stop_attrs) if override
    }
  end


end
