class Route < ActiveRecord::Base

  has_and_belongs_to_many :stops

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

  private

  BASE_URL = "http://chalobest.in/1.0"

  def uri
    BASE_URL + url[0..-2]
  end


end
