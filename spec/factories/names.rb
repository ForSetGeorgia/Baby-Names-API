FactoryBot.define do
  factory :name do
    name_ka { Faker::Name.first_name }
    name_en { Faker::Name.first_name }
    gender 'f'
  end
end