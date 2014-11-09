require 'spec_helper'

describe LocationReport do

  fixtures :stops
  fixtures :routes
  fixtures :routes_stops

  let!(:lr1) { LocationReport.create(stop_id: 498, route_id: 183, heading: 1) }
  let!(:stop4) { Stop.find(1662) }
  it "should work" do
    ap Arrival.count
    binding.pry
    ap stop4.arrivals.to_a
  end

end
