require "spec_helper"

describe Glysellin::DiscountType do
  it { should have_many(:discount_codes) }
  it { should have_many(:discounts) }

  before(:each) do
    @discount_type = create(:discount_type)
  end

  describe '#to_s' do
    [
      ['order-percentage', '%'],
      ['fixed-price', '€']
    ].each do |(identifier, value)|
      it 'returns string value of object' do
        @discount_type.identifier = identifier
        expect(@discount_type.to_s).to eq value
      end
    end
  end
end
