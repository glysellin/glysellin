require "factory_girl"

FactoryGirl.define do
  factory :sellable, class: Glysellin::Sellable do
    sequence(:name) { |n| "Product #{ n }" }
    price (0..1000).to_a.sample
    eot_price (0..1000).to_a.sample
    taxonomy

    before(:create) do |sellable, evaluator|
      sellable.variants << create(:variant)
    end
  end

  factory :variant, class: Glysellin::Variant do
    sequence(:name) { |n| "Variant #{ n }" }
    eot_price (0..1000).to_a.sample
    price (0..1000).to_a.sample
  end

  factory :property, class: Glysellin::Property do
    sequence(:value) { |n| "VariantProperty #{ n }" }
    barcode_ref '013245678912'
  end

  factory :stock, class: Glysellin::Stock
  factory :shipment, class: Glysellin::Shipment
  factory :payment, class: Glysellin::Payment

  factory :brand, class: Glysellin::Brand do
    sequence(:name) { |n| "Brand #{ n }" }
  end

  factory :abstract_order, class: Glysellin::AbstractOrder do
    customer { create(:customer) }
    shipping_address { create(:address) }
    billing_address { create(:address) }

    before(:create) do |abstract_order, evaluator|
      abstract_order.parcels << create(:parcel)
    end
  end

  factory :store, class: Glysellin::Store do
    sequence(:name) { |n| "Store #{ n }" }
  end

  factory :property_type, class: Glysellin::PropertyType do
    sequence(:name) { |n| "PropertyType #{ n }" }
    identifier { name.parameterize }
  end

  factory :taxonomy, class: Glysellin::Taxonomy do
    sequence(:name) { |n| "Taxonomy #{ n }" }
  end

  factory :line_item, class: Glysellin::LineItem do
    sequence(:name) { |n| "LineItem #{ n }" }
    sequence(:vat_rate) { |n| n }
    sequence(:quantity) { |n| n }
    price 10.0
    eot_price 10.0
  end

  factory :parcel, class: Glysellin::Parcel do
    sequence(:name) { |n| "Parcel #{ n }" }

    before(:create) do |parcel, evaluator|
      parcel.line_items << create(:line_item)
    end
  end

  factory :order, class: Glysellin::Order do
    customer
    billing_address { create(:address) }
    shipping_address { create(:address) }

    before(:create) do |order, evaluator|
      order.parcels << create(:parcel)
    end
  end

  factory :address, class: Glysellin::Address do
    sequence(:first_name) { |n| "First name #{ n }" }
    sequence(:last_name) { |n| "Last name #{ n }" }
    sequence(:address) { |n| "Address #{ n }" }
    sequence(:zip) { |n| "Zip #{ n }" }
    sequence(:city) { |n| "City #{ n }" }
    sequence(:country) { |n| "Country #{ n }" }
  end

  factory :customer, class: Glysellin::Customer do
    first_name 'first_name'
    last_name 'last_name'
    sequence(:email) { |n| "customer-#{ n }@example.com" }
  end

  factory :user, class: User do
    sequence(:email) { |n| "user-#{ n }@example.com" }
    password 'password'
    password_confirmation 'password'
    confirmed_at Time.now
  end

  factory :discount_code, class: Glysellin::DiscountCode do
    sequence(:name) { |n| "discount-#{ n }" }
    sequence(:code) { |n| "code-#{ n }" }
    value 5
    expires_on { 10.days.from_now }
    discount_type
  end

  factory :discount_type, class: Glysellin::DiscountType do
    sequence(:name) { |n| "Discount Type #{ n }" }
    sequence(:identifier) { |n| "identifier-#{ n }" }
  end
end

