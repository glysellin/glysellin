require "spec_helper"

describe Glysellin::Variant do
  it { should belong_to(:sellable) }
  it { should have_many(:properties) }
  it { should accept_nested_attributes_for(:properties) }

  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:price) }
  it { should validate_numericality_of(:in_stock) }

  let(:sellable) { FactoryGirl.build(:sellable) }
  let(:variant) { FactoryGirl.build(:variant, sellable: sellable) }

  context "before validation" do
    it "checks prices" do
      expect(variant).to receive(:check_prices)
      variant.save
    end
  end

  describe ".available" do
    it "returns all variants published and with stock to be bought" do
      available_variant = FactoryGirl.create(
        :variant, published: true, unlimited_stock: true
      )
      expect(Glysellin::Variant.available).to include(available_variant)
    end

    it "doesn't return unpublished variants" do
      unpublished_variant = FactoryGirl.create(:variant, published: false)
      expect(Glysellin::Variant.available).not_to include(unpublished_variant)
    end

    it "doesn't return items with no stock" do
      no_stock_variant = FactoryGirl.create(
        :variant, published: true, unlimited_stock: false, in_stock: 0
      )
      expect(Glysellin::Variant.available).not_to include(no_stock_variant)
    end
  end

  describe ".published" do
    it "returns all published variants" do
      published_variant = FactoryGirl.create(:variant, published: true)
      expect(Glysellin::Variant.published).to include(published_variant)
    end

    it "does't return unpublished variants" do
      unpublished_variant = FactoryGirl.create(:variant, published: false)
      expect(Glysellin::Variant.published).not_to include(unpublished_variant)
    end
  end

  describe "#description" do
    it "returns the associated sellable's description when a sellable is set" do
      allow(variant).to receive(:sellable) { double(description: "text") }
      expect(variant.description).to eq("text")
    end

    it "returns an empty string when no sellable is set" do
      variant.sellable = nil
      expect(variant.description).to eq("")
    end
  end
end