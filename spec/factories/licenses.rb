FactoryBot.define do
  factory :license do
    key { Faker::Commerce.unique.promotion_code(digits: 6) }
    platform { %i[steam battle_net origin].sample }
    status { %i[available currently_using inactive].sample }
    game
  end
end
