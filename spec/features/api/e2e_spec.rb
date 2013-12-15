require 'spec_helper'

describe "End To End Spec" do

  before(:all) {
    User.destroy_all
    Trip.destroy_all
  }
  let(:host) { "http://localhost:3000" }
  let(:base_url) { "#{host}/api/v1"}
  let(:email) { "foo#{rand(1000)}@bar.com" }
  let!(:start_stop) { FactoryGirl.create(:stop) }
  let!(:end_stop) { FactoryGirl.create(:stop) }
  let(:trip_params) {
    {
      :bus_number => 2010,
      :end_stop_code => end_stop.id,
      :start_stop_code => start_stop.id,
      :start_stop_name => start_stop.name,
      :end_stop_name => end_stop.name
    }
  }
  it "should work end to end" do
    r = RestClient.post("#{base_url}/users", {'user[email]' => email, 'user[password]' => "foobar", 'user[password_confirmation]' => "foobar"})
    r.code.should == 200
    auth_token = JSON.load(r)["auth_token"]
    ap "Creating Trip with params "
    ap trip_params
    r = RestClient.post("#{base_url}/trips", :trip => trip_params, :user_email => email, :user_token => auth_token)
    r.code.should == 200
    trip_id = JSON.load(r)["id"]
    r = RestClient.post("#{base_url}/location_reports", 'location_report[trip_id]' => trip_id, 'location_report[lat]' => 1, 'location_report[lon]' => 1, :user_email => email, :user_token => auth_token)
    ap JSON.load(r)
    r.code.should == 200
  end

end
