require 'spec_helper'

describe User do

  it { should have_many :trips }

  it "should add auth_token" do
    u = FactoryGirl.build(:user).tap{|u| u.save }
    u.auth_token.should_not be_nil
  end

end
