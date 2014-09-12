class Route < ActiveRecord::Base

  has_many :routes_stops
  has_many :stops, -> {order 'routes_stops.order'}, through: :routes_stops

  def self.update!
    JSON.load(RestClient.get("http://chalobest.in/1.0/routes")).each do |ra|
      Route.create(ra.slice(*Route.attribute_names).except("id"))
    end
  end

  def stops_array
    @stops_array ||= JSON.load(RestClient.get(uri))["stops"]["features"]
  end

  def update!(overwrite = false)
    stops_array.each do |sa|
      self.stops << Stop.create_from_chalo_best(sa, overwrite)
    end
  end

  def order_stops!
    factory = RGeo::Geos.factory(srid: 4326)
    points = []
    stops_array.each_with_index do |bs,i|
      n = bs["properties"]["slug"]
      s = Stop.find_by_slug(n)
      p [n,s.official_name]
      rs = RoutesStop.where(route_id: id, stop_id: s.id).first
      if rs
        rs.order = i + 1
        rs.save
        p "set order #{i} on RoutesStop #{rs.id}"
      end
      points << factory.point(s.lon, s.lat)
    end
    self.geometry = factory.line_string(points)
    save

  end

  def points
    binding.pry
  end

  def self.near(lat, lon, dist = 100)
    Route.where('ST_Distance_Sphere(geometry, ST_SetSRID(ST_MakePoint(?,?), 4326)) < ?',lon.to_f, lat.to_f, dist)
  end



  private

  BASE_URL = "http://chalobest.in/1.0"

  def uri
    BASE_URL + url[0..-2]
  end


end
