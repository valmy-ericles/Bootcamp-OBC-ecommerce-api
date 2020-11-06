FactoryBot.define do
  factory :product do
    sequence(:name) { |m| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::commerce.price(range: 10.0..400.0) }
    productable { nil }
  end
end
