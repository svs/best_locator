require 'spec_helper'

describe MapSquare do

  let!(:malad) { FactoryGirl.create(:stop, :display_name => "Malad", :area => "M", :lat => 10, :lon => 10) }
  let!(:bandra) { FactoryGirl.create(:stop, :display_name => "Bandra", :area => "B", :lat => 1, :lon => 1) }
  let!(:thane)  { FactoryGirl.create(:stop, :area => "T", :lat => 100, :lon => 100) }

  let!(:map_square) { FactoryGirl.create(:map_square, :lat1 => 0, :lon1 => 0, :lat2 => 15, :lon2 => 15) }

  subject { :map_square }

  it "should have correct stops" do
    map_square.stops.should == [bandra, malad]
    map_square.stops(sort: :lat).should == [malad, bandra]
  end


end
