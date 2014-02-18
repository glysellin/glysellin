require "spec_helper"

describe Glysellin::DiscountCode do
  it_behaves_like "an adjustment"

  it { should belong_to(:discount_type) }
  it { should have_many(:order_adjustments) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:discount_type) }
  it { should validate_presence_of(:value) }

  describe "#code=" do
    it "downcases the passed code" do
      discount_code = FactoryGirl.build(:discount_code)
      discount_code.code = "AZE123FA"
      expect(discount_code.code).to eq "aze123fa"
    end
  end

  describe "#applicable?" do
    it "returns true if the code has no expiration date" do
      discount_code = FactoryGirl.build(:discount_code, expires_on: nil)
      expect(discount_code.applicable?).to eq(true)
    end

    it "returns true if the code has an expiration date that is in the future" do
      discount_code = FactoryGirl.build(:discount_code, expires_on: 3.days.from_now)
      expect(discount_code.applicable?).to eq(true)
    end

    it "returns fale if the code has an expiration date that is in the past" do
      discount_code = FactoryGirl.build(:discount_code, expires_on: 20.minutes.ago)
      expect(discount_code.applicable?).to eq(false)
    end
  end
end