FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
    description  { Faker::Company.bs }
    contact_name { Faker::Name.name  }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end