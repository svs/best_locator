require 'spec_helper'

describe Api::V1::TripsController do

  let!(:user) { FactoryGirl.create(:user) }
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
      t = Trip.create(valid_params["trip"].merge(:user_id => user.id))
      get(:index)
      r = JSON.load(response.body)
      r[0].should be_a Hash
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
