# -*- coding: utf-8 -*-
require 'spec_helper'

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

end
