FactoryBot.define do
  factory :market do
    name { Faker::Company.name }
    street  { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::PhoneNumber.phone_number }
    state { Faker::Boolean.boolean }
    zip { Faker::Address.state }
    lat { Faker::Number.decimal(l_digits: 2, r_digits: 6)
    lon { Faker::Number.negative.decimal(l_digits: 3, r_digits: 6)
  end
end