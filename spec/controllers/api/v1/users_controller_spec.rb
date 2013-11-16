require 'spec_helper'

describe Api::V1::UsersController do

  let!(:user) { FactoryGirl.create(:user) }

  context "unauthenticated user" do
    it "should return 402" do
      get(:show, :id => 1)
      response.status.should == 302
    end
  end

  context "authenticated user" do
    before(:each) {
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(user)
    }

    it "should give user details for own user" do
      get(:show, :id => user.id, :format => :json)
      response.status.should == 200
      r = JSON.load(response.body)
      r["email"].should == user.email
    end
  end


end
