task :add_order_to_routes_stops => :environment do

  Route.all.each do |r|
    ap r.code
    r.order_stops!
  end


end
