require "factory_girl"

FactoryGirl.define do
  factory :product, class: Glysellin::Product do
  end

  factory :order, class: Glysellin::Order do
    customer { FactoryGirl.create(:customer) }
    billing_address { FactoryGirl.create(:address) }
    shipping_address { FactoryGirl.create(:address) }
  end

  factory :address, class: Glysellin::Address do
    sequence(:first_name) { |n| "First name #{ n }" }
    sequence(:last_name) { |n| "Last name #{ n }" }
    address "Address"
    zip "11223"
    city "City"
    country "Country"
  end

  factory :customer, class: Glysellin.user_class_name.constantize do
    sequence(:email) { |n| "customer-#{ n }@example.com" }
    password "azerty123"
    password_confirmation "azerty123"
  end

  factory :discount_code, class: Glysellin::DiscountCode do
    sequence(:name) { |n| "discount-#{ n }" }
    sequence(:code) { |n| "code-#{ n }" }
    value 5
    discount_type { FactoryGirl.build(:discount_type) }
    expires_on { 10.days.from_now }
  end

  factory :discount_type, class: Glysellin::DiscountType do
    sequence(:name) { |n| "Discount Type #{ n }" }
    sequence(:identifier) { |n| "identifier-#{ n }" }
  end
end

