FactoryGirl.define do
  factory :product_mirror do
    sequence(:name) { |i| "product#{i}"}
    sequence(:price) { |i| i }
    sequence(:quantity) { |i| i}
    user_id 5
    sequence(:external_id) { |i| i}
    external_created_at DateTime.now
    external_updated_at DateTime.now
  end
end


