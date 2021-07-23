FactoryBot.define do
  factory :product do
    quantity { 20 }
    description { Faker::Lorem.paragraph }
  end
end
