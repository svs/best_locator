require 'spec_helper'

describe Api::V1::TripsController do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:my_trip) { Trip.create(valid_params["trip"].merge(:user_id => user.id)) }
  let!(:others_trip) { FactoryGirl.create(:trip) }
  let(:valid_params) { {"trip" => {}, :format => "json"}}

  context "unauthenticated" do

    it "should respond with 302" do
      post(:create, {})
      response.status.should == 302
      get(:index)
      response.status.should == 302
    end

  end


  context "authenticated" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(user)
    end

    it "should create a trip" do
      expect {
        post(:create, {"trip" => {}, :format => "json"})
      }.to change(Trip, :count).by(1)
    end

    it "should index" do
      get(:index)
      r = JSON.load(response.body)
      r[0].should be_a Hash
    end

    describe "show" do
      it "is allowed for own trip" do
        get(:show, :id => my_trip.id)
        response.status.should == 200
      end
    end

    it "raises 404 for others trip" do
      get(:show, :id => others_trip.id)
      response.status.should == 404
    end

  end

  context "API token" do
    let(:valid_api_params) { valid_params.merge(:user_email => user.email, :user_token => user.auth_token) }
    it "should 200" do
      post(:create, valid_api_params)
      response.status.should == 200
    end

    it "should create a trip" do
      expect {
        post(:create, valid_api_params)
      }.to change(Trip, :count).by(1)
    end
  end





end
