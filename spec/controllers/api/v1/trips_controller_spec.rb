require 'spec_helper'

describe Api::V1::TripsController do

  let!(:user) { FactoryGirl.create(:user) }
  let(:valid_params) { {"trip" => {}, :format => "json"}}
  context "unauthenticated" do

    it "should 302" do
      post(:create, {})
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
