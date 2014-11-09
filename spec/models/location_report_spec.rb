require 'spec_helper'

describe LocationReport do

  fixtures :stops
  fixtures :routes
  fixtures :routes_stops

  let!(:lr1) { LocationReport.create(stop_id: 498, route_id: 183, heading: 1) }
  let!(:lr2) { LocationReport.create(stop_id: 498, route_id: 183, heading: 1) }
  let!(:lr3) { LocationReport.create(stop_id: 498, route_id: 183, heading: -1) }
  let!(:stop_before) { Stop.find(497) }
  let!(:stop_after) { Stop.find(1662) }

  it "should work" do
    expect(stop_after.arrivals.count).to eql(2)
    expect(stop_before.arrivals.count).to eql(1)
  end

end
