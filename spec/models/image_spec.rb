require "spec_helper"

describe Glysellin::Image do
  it { should belong_to(:imageable) }
  it { should have_attached_file(:image) }

  before(:each) do
    @discount_type = create(:discount_type)
  end

  describe '#image_url' do
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
