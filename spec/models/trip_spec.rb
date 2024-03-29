require 'spec_helper'

describe Trip do

  it { should validate_presence_of :user_id }
  its(:status) { should == "new" }

  it "should start and stop" do
    t = FactoryGirl.create(:trip)
    t.should be_fresh
    t.should be_startable
    t.user.should_not have_live_trip
    t.start!
    t.should be_started
    t.started_at.should_not be_nil
    t.user.should have_live_trip
    t.should be_stoppable
    t.stop!
    t.should be_stopped
  end


end
