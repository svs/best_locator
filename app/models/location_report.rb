class LocationReport < ActiveRecord::Base

  belongs_to :route
  belongs_to :stop

  after_save :mark_arrivals


  private

  def mark_arrivals
    return true if (stop.nil? || route.nil? || heading.nil?)
    subsequent_stops.each do |s|
      stops_away = (s.order - this_stop.order).abs
      a = {stop_id: s.stop_id,
        route_id: route.id,
        stops_away: stops_away,
        report_time: self.created_at,
        report_id: self.id,
        heading: self.heading
      }
      $redis.setex("#{s.stop_id}:#{route.id}:#{self.id}", 600 * stops_away, a.to_json )
      Pusher.trigger_async("stop-#{s.stop_id}","arrival",a)
    end
  end

  def subsequent_stops
    RoutesStop.where("route_id = ? AND \"order\" #{{1 => '>', -1 => '<'}[heading.to_i]}  ?", route.id, this_stop.order)
  end

  def this_stop
    @this_stop ||= RoutesStop.where(route_id: route.id, stop_id: stop.id).first
  end

end
