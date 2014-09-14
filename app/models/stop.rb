class Stop < ActiveRecord::Base

  has_many :routes_stops
  has_many :routes, through: :routes_stops

  has_many :start_trips, :foreign_key => :start_stop_id, :class_name => Trip
  has_many :end_trips, :foreign_key => :end_stop_id, :class_name => Trip


  def as_json(include_root = false)
    attributes.merge(routes: routes.uniq)
  end

  def self.attrs_from_chalo_best(json)
    json["properties"].slice(*self.attribute_names).except("id", "routes").
      merge("lat" => json["geometry"]["coordinates"][1], "lon" => json["geometry"]["coordinates"][0]).tap do |attrs|
      attrs["route_names"] = JSON.dump("ids" => json["properties"]["routes"])
    end
  end

  def self.create_from_chalo_best(json, override = false)
    bus_stop_attrs = attrs_from_chalo_best(json)
    bs = Stop.where("slug" => bus_stop_attrs["slug"]).first_or_create(bus_stop_attrs).tap{|b|
      b.update_attributes(bus_stop_attrs) if override
    }
  end

  def self.search_by(params)
    if params[:center_lat] && params[:center_lon]
      lat = params[:center_lat].to_f
      lon = params[:center_lon].to_f
      Stop.order("abs(lat - #{lat}) + abs(lon - #{lon})").limit(10)
    elsif params[:map_square_id]
      MapSquare.find(params[:map_square_id]).stops(params[:sort])
    elsif params[:lat1] && params[:lat2] && params[:lon1] && params[:lon2]
      Stop.in_square(params[:lat1], params[:lon1], params[:lat2], params[:lon2])
    elsif params[:area]
      Stop.where(:area => params[:area]).order(:display_name)
    elsif params[:faves]
      Stop.where(:id => Stop.joins('join trips on trips.start_stop_id = stops.id or trips.end_stop_id = stops.id').
                 select('stops.id as id,count(trips.id) as ct').
                 group('stops.id').
                 order('ct desc').
                 limit(5).
                 map(&:id))
    end
  end

  def self.in_square(lat1, lon1, lat2, lon2)
    lon1, lon2 = lon2, lon1 if lon2 < lon1
    lat1, lat2 = lat2, lat1 if lat2 < lat1
    Stop.where('(lat between ? and ?) and (lon between ? and ?)', lat1, lat2, lon1, lon2)
  end

  def self.inspect
    self.to_s
  end

end
