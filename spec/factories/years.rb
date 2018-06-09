FactoryBot.define do
  factory :year do
    year { Faker::Number.number(4) }
    name_id nil
  end
end