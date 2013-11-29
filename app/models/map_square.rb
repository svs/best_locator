class MapSquare < ActiveRecord::Base

  def stops(sort: :alpha)

    Stop.in_square(lat1, lon1, lat2, lon2).order((sort.to_sym == :alpha ? :display_name : 'lat desc'))
  end

  def areas(sort: :alpha)
    if sort.to_sym == :alpha
      self.stops.map(&:area).uniq.sort
    else
      self.stops(sort: :lat).map(&:area).uniq
    end
  end

end
