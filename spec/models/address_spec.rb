require "spec_helper"

describe Glysellin::Address do
  it { should belong_to(:shipped_addressable) }
  it { should belong_to(:billed_addressable) }

  it "validates all keys configured to be required" do
    Glysellin.address_presence_validation_keys.each do |key|
      expect(subject).to validate_presence_of(key)
    end
  end

  describe "#same_as?" do
    it "returns true if #clone_attributes of both Address objects are equal" do
      first_address = FactoryGirl.build(:address)
      second_address = FactoryGirl.build(:address)
      allow(first_address).to receive(:clone_attributes) { { a: 1 } }
      allow(second_address).to receive(:clone_attributes) { { a: 1 } }
      expect(first_address.same_as?(second_address)).to eq(true)
    end

    it "returns false if #clone_attributes of both Address objects aren't equal" do
      first_address = FactoryGirl.build(:address)
      second_address = FactoryGirl.build(:address)
      allow(first_address).to receive(:clone_attributes) { { a: 1 } }
      allow(second_address).to receive(:clone_attributes) { { a: 2 } }
      expect(first_address.same_as?(second_address)).to eq(false)
    end
  end

  describe "#clone_attributes" do
    let(:address) { FactoryGirl.build(:address) }

    it "returns all the relevant model's attributes to create a similar one" do
      [
        "first_name", "last_name", "address", "city", "zip", "country"
      ].each do |key|
        expect(address.clone_attributes.keys).to include(key)
      end
    end

    it "doesn't return unique attributes" do
      [
        "id", "created_at", "updated_at",
        "billed_addressable_id", "billed_addressable_type",
        "shipping_addressable_id", "shipped_addressable_type"
      ].each do |key|
        expect(address.clone_attributes.keys).not_to include(key)
      end
    end
  end
end