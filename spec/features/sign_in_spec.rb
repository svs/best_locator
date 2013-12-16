require 'spec_helper'

describe "Sign up and sign in", :js => true do

  before(:all) { User.destroy_all }

  it "should sign up" do
    visit new_user_registration_path
    fill_in 'user_email', with: 'foo@bar.com'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'
    click_on 'Sign up'
    page.should have_content 'success'
  end

end
