require "spec_helper"

describe Glysellin::Variant do
  it { should belong_to(:sellable) }

  it { should have_many(:properties) }
  it { should have_many(:stocks) }
  it { should have_many(:stores) }
  it { should have_many(:variant_properties) }
  it { should have_many(:properties) }

  it { should have_many(:imageables) }
  it { should have_many(:images) }
  it { should have_many(:line_items) }

  it { should accept_nested_attributes_for(:variant_properties) }
  it { should accept_nested_attributes_for(:imageables) }
  it { should accept_nested_attributes_for(:stocks) }

  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:eot_price) }
  it { should validate_numericality_of(:price) }

  before(:each) do
    @variant = create(:variant)
  end

  context "before validation" do
    it "checks prices" do
      expect(@variant).to receive(:check_prices)
      @variant.save
    end
  end

  describe '.stocks_for_all_stores' do
    it 'returns stocks for all stores' do
      store_1 = create(:store)
      store_2 = create(:store)
      store_3 = create(:store)
      store_4 = create(:store)

      stock_1 = create(:stock, store: store_1)
      stock_2 = create(:stock, store: store_2)
      stock_3 = create(:stock, store: store_3)
      stock_4 = create(:stock, store: store_4)

      @variant.stocks << stock_1
      @variant.stocks << stock_2
      @variant.stocks << stock_3

      hash = {}
      hash[store_1] = stock_1
      hash[store_2] = stock_2
      hash[store_3] = stock_3
      hash[store_4] = build(:stock, store: store_4, variant: @variant)

      expect(@variant.stocks_for_all_stores[store_1]).to eq hash[store_1]
      expect(@variant.stocks_for_all_stores[store_2]).to eq hash[store_2]
      expect(@variant.stocks_for_all_stores[store_3]).to eq hash[store_3]
      expect(@variant.stocks_for_all_stores[store_4].new_record?).to eq hash[store_4].new_record?
    end
  end

  describe '.properties_hash' do
    it 'returns a hash with identifier -> property' do
      property_type_1 = create(:property_type, identifier: '001')
      property_type_2 = create(:property_type, identifier: '002')

      property_1 = create(:property, value: 'Propriété 1', property_type: property_type_1)
      property_2 = create(:property, value: 'Propriété 2', property_type: property_type_2)

      @variant.properties << property_1
      @variant.properties << property_2

      hash = {}
      hash['001'] = property_1
      hash['002'] = property_2

      expect(@variant.properties_hash).to eq hash
    end
  end

  describe '.custom_name' do
    it 'returns the variant custom_name if no properties' do
      variant = create(:variant, name: 'Jaune', properties: [])
      sellable = create(:sellable, name: 'Tshirt', variants: [variant])
      expect(variant.custom_name).to eq 'Tshirt — Jaune'
    end

    it 'returns the variant custom_name if no properties' do
      variant = create(:variant, name: 'Jaune', properties: [])
      sellable = create(:sellable, name: 'Tshirt', variants: [variant])
      variant.properties << create(:property, value: 'Propriété 1')
      variant.properties << create(:property, value: 'Propriété 2')
      expect(variant.custom_name).to eq 'Tshirt — Propriété 1, Propriété 2'
    end
  end

  describe '.price' do
    it 'returns sellable price if no variant price present' do
      sellable = create(:sellable, variants: [@variant])
      @variant.price = nil
      @variant.save!
      expect(@variant.price).to eq sellable.price
    end

    it 'returns variant price if present' do
      sellable = create(:sellable, variants: [@variant])
      @variant.price = 10
      @variant.save!
      expect(@variant.price).to eq 10
    end
  end

  describe '.eot_price' do
    it 'returns sellable price if no variant price present' do
      sellable = create(:sellable, variants: [@variant])
      @variant.eot_price = nil
      @variant.save!
      expect(@variant.price).to eq sellable.price
      expect(@variant.eot_price).to eq sellable.eot_price
    end

    it 'returns variant price if present' do
      sellable = create(:sellable, variants: [@variant])
      @variant.eot_price = 10
      @variant.save!
      expect(@variant.eot_price).to eq 10
    end
  end

  describe '.vat_rate' do
    it 'returns default vat_rate' do
      expect(@variant.vat_rate).to eq Glysellin.default_vat_rate
    end
  end

  describe '.vat_ratio' do
    it 'returns the variant vat_ratio' do
      expect(@variant.vat_ratio).to eq (1 + @variant.vat_rate / 100)
    end
  end

  describe ".published" do
    it "returns all published variants" do
      published_variant = create(:variant, published: true)
      expect(Glysellin::Variant.published).to include(published_variant)
    end

    it "does't return unpublished variants" do
      unpublished_variant = create(:variant, published: false)
      expect(Glysellin::Variant.published).not_to include(unpublished_variant)
    end
  end

  describe ".description" do
    it "returns the associated sellable's description when a sellable is set" do
      allow(@variant).to receive(:sellable) { double(description: "text") }
      expect(@variant.description).to eq("text")
    end

    it "returns an empty string when no sellable is set" do
      @variant.sellable = nil
      expect(@variant.description).to eq("")
    end
  end
end
