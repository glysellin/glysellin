require "spec_helper"

describe Glysellin::Sellable do
  it { should belong_to(:sellable) }
  it { should belong_to(:brand) }
  it { should validate_numericality_of(:vat_rate) }

  let(:sellable) { FactoryGirl.create(:sellable) }

  describe ".publshed" do
    before do
      @published_sellable = FactoryGirl.create(:sellable)
      @unpublished_sellable = FactoryGirl.create(:sellable)

      @published_sellable.variants.create(
        FactoryGirl.attributes_for(:variant, published: true)
      )
      @unpublished_sellable.variants.create(
        FactoryGirl.attributes_for(:variant, published: false)
      )
    end

    it "returns all products that have published variants" do
      expect(Glysellin::Sellable.published).to include(@published_sellable)
    end

    it "does not return products with no published variants" do
      expect(Glysellin::Sellable.published).not_to include(@unpublished_sellable)
    end
  end

  describe "#vat_rate" do
    it "returns the :vat_rate column's value when set" do
      sellable.vat_rate = 20
      expect(sellable.vat_rate).to eq 20
    end

    it "returns the global default VAT rate when column is null" do
      Glysellin.default_vat_rate = 10
      expect(sellable.vat_rate).to eq 10
    end
  end

  describe "#vat_ratio" do
    it "returns the ratio to multiply prices with to obtain the total price" do
      sellable.vat_rate = 5
      expect(sellable.vat_ratio).to eq 1.05
    end
  end

  describe "#published_variants" do
    it "returns the associated variants that are published" do
      allow(sellable).to receive(:variants) { double(published: [])}
      expect(sellable.published_variants).to eq []
    end
  end
end