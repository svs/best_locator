FactoryGirl.define do
  sequence(:email)          { |n| "my_email@example#{n}.com" }

  factory :user do
    email
    password "123456"
    password_confirmation "123456"
  end

  factory :trip do
    association :user
  end

  factory :stop do
    sequence(:name) { |n| "Stop#{n}" }
    lat 1
    lon 1
    sequence(:area) { |n| "Area#{100-n}" }
  end

  factory :map_square do
    lat1 0
    lon1 0
    lat2 2
    lon2 0
  end

end
