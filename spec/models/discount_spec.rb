require "spec_helper"

describe Glysellin::Discount do
  it { should belong_to(:discountable) }
  it { should belong_to(:discount_type) }

  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:discount_type_id) }

  # describe '#eot_price' do
  #   it 'returns the eot_price' do
  #     discount = create(:discount, price: 10.0)
  #     discount.discountable = create(:order, vat_rate: 0.2)
  #     expect(discount.eot_price).to eq 8.0
  #   end
  # end
end
