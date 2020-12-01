FactoryBot.define do
  factory :license do
    key { Faker::Commerce.unique.promotion_code(digits: 6) }
    user
    game
  end
end
