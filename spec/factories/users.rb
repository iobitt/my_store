FactoryGirl.define do
  factory :user do
    sequence(:name) { |i| "user#{i}"}
    password "12891289"
    type "Manager"
  end
end
