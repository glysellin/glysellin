require "spec_helper"

describe Glysellin::Product do
  it { should belong_to(:sellable) }
  it { should belong_to(:brand) }
  it { should validate_numericality_of(:vat_rate) }

  let(:product) { create(:product) }

  describe "#name" do
    it "returns nil when associated with a sellable" do
      expect(product.name).to be_nil
    end

    it "returns the associated sellable's name" do
      allow(product).to receive(:sellable) { double(name: "name") }
      expect(product.name).to eq("name")
    end
  end

  describe "#vat_rate" do
    it "returns the :vat_rate column's value when set" do
      product.vat_rate = 20
      expect(product.vat_rate).to eq 20
    end

    it "returns the global default VAT rate when column is null" do
      Glysellin.default_vat_rate = 10
      expect(product.vat_rate).to eq 10
    end
  end

  describe "#vat_ratio" do
    it "returns the ratio to multiply prices with to obtain the total price" do
      product.vat_rate = 5
      expect(product.vat_ratio).to eq 1.05
    end
  end

  describe "#variants" do
    it "returns the associated sellable's published variants" do
      allow(product).to receive(:sellable) { double(published_variants: [])}
      expect(product.variants).to eq []
    end
  end
end