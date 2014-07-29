require "spec_helper"

describe Glysellin::DiscountCode do
  it { should belong_to(:discount_type) }
  it { should have_many(:order_adjustments) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:discount_type) }
  it { should validate_presence_of(:value) }

  describe "#code=" do
    it "downcases the passed code" do
      discount_code = build(:discount_code)
      discount_code.code = "AZE123FA"
      expect(discount_code.code).to eq "aze123fa"
    end
  end

  describe "#applicable_for?(price)" do
    before(:each) do
      @discount_code = create(:discount_code)
    end

    [
      [true,  true,  false, false,  true],
      [true,  true,  false, true,   true],
      [true,  true,  true,  false, false],
      [true,  true,  true,  true,   true],
      [true,  false, true,  false, false],
      [true,  false, true,  true,  false],
      [true,  false, false, true,  false],
      [true,  false, false, false, false],
      [false, true,  true,  false, false],
      [false, true,  true,  true,   true],
      [false, true,  false, true,   true],
      [false, true,  false, false,  true],
      [false, false, true,  true,   true],
      [false, false, true,  false, false],
      [false, false, false, true,   true],
      [false, false, false, false,  true]
    ].each do |(expires_on_presence, expires_on_gt_than_time_now, order_minimum_presence, order_minimum_lteq_than_price, expected_result)|

      it "execites applicable_for? with following arguments: {
        (
          #{expires_on_presence},
          #{expires_on_gt_than_time_now},
          #{order_minimum_presence},
          #{order_minimum_lteq_than_price},
          #{expected_result}
        )
      }" do
        price = rand(1000)

        if expires_on_presence
          @discount_code.expires_on = expires_on_gt_than_time_now ? (Time.now + 1.day) : (Time.now - 1.day)
        end

        if order_minimum_presence
          @discount_code.order_minimum = order_minimum_lteq_than_price ? (price - rand(0..10)) : (price + rand(10))
        end

        expect(@discount_code.applicable_for?(price)).to eq expected_result
      end
    end
  end
end