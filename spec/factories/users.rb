FactoryBot.define do
  factory :user do
    email { Faker::Internet.email.upcase }
    full_name { Faker::Name.name }
    password {"tranbao"}
    password_confirmation {"tranbao"}
    phone { "0877654121" }
    address { Faker::Address.full_address }
  end
end
