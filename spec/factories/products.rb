FactoryGirl.define do
  factory :product do
    sequence(:name) { |i| "product#{i}"}
    price 30
    quantity 50
    user_id 5
  end
end

