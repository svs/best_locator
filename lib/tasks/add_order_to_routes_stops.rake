task :add_order_to_routes_stops => :environment do

  Route.all.each do |r|
    ap r.code
    r.stops_array.each_with_index do |bs,i|
      n = bs["properties"]["official_name"]
      s = Stop.find_by_official_name(n)
      ap s.official_name
      rs = RoutesStop.where(route_id: r.id, stop_id: s.id).first
      if rs
        rs.order = i + 1
        rs.save
      end
    end
  end


end
