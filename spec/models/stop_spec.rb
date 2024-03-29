# -*- coding: utf-8 -*-
require 'spec_helper'
require 'rake'

describe Stop do
  let(:json) {
    {
      "geometry"=>{"type"=>"Point", "coordinates"=>[72.81144385329749, 18.896618479846932]},
      "type"=>"Feature",
      "properties"=>{
        "area_url"=>"/area/colaba/",
        "direction"=>"",
        "code"=>37,
        "official_name"=>"R.C.CHURCH",
        "road_mr"=>"नानाभाइ मुस मार्ग",
        "area_mr"=>"कुलाबा",
        "id"=>"abc",
        "display_name"=>"R.C.Church",
        "area"=>"Colaba",
        "url"=>"/stop/rcchurch",
        "slug"=>"rcchurch",
        "name_mr"=>"आर.सी.चर्च",
        "routes"=>"1, 2 Ltd, 21 Ltd, 103, 106, 106, 123",
        "alternative_names"=>"",
        "road"=>"Nanabhai Moos Marg"}
    }
  }


  describe "create from chalo best" do
  let!(:bus_stop) { Stop.create_from_chalo_best(json) }

    it { should be_a Stop }
    specify {
      bus_stop.official_name.should == "R.C.CHURCH"
      bus_stop.id.should_not == "abc"
    }
  end


  describe "searching stops" do
    let!(:malad) { FactoryGirl.create(:stop, :display_name => "Malad", :area => "M", :lat => 10, :lon => 10) }
    let!(:bandra) { FactoryGirl.create(:stop, :display_name => "Bandra", :area => "B", :lat => 1, :lon => 1) }

    specify { Stop.search_by(:center_lat => 2, :center_lon => 2).should == [bandra, malad] }
    specify { Stop.search_by(:lat1 => 0, :lon1 => 0, :lat2 => 2, :lon2 => 2).should == [bandra] }

  end

end
