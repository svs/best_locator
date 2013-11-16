FactoryGirl.define do
  sequence(:email)          { |n| "my_email@example#{n}.com" }

  factory :user do
    email
    password "123456"
    password_confirmation "123456"
  end
end
