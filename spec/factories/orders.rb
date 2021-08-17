FactoryBot.define do
  factory :order do
    full_name { Faker::Name.name }
    address { Faker::Address.full_address}
    phone { "0877654121"}
    email { Faker::Internet.email}
  end
end
