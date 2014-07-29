require 'spec_helper'

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

  context 'before validation' do
    it 'checks prices' do
      expect(@variant).to receive(:check_prices)
      @variant.save
    end
  end

  describe '#stocks_for_all_stores' do
    it 'returns a stock for all the existing stores, building those which do not exist' do
      store_1 = create(:store)
      store_2 = create(:store)

      stock = create(:stock, store: store_1, count: 10)

      @variant.stocks << stock

      expect(@variant.stocks_for_all_stores[store_1]).to eq stock
      expect(@variant.stocks_for_all_stores[store_2]).to be_instance_of Glysellin::Stock
    end
  end

  describe '#properties_hash' do
    it 'returns a hash with identifier -> property' do
      property_type = create(:property_type, identifier: '001')
      property = create(:property, value: 'Propriété 1', property_type: property_type)
      @variant.properties << property

      expect(@variant.properties_hash['001']).to eq property
    end
  end

  describe '#custom_name' do
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

  describe '#price' do
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

  describe '#eot_price' do
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

  describe '#vat_rate' do
    it 'returns default vat_rate' do
      expect(@variant.vat_rate).to eq Glysellin.default_vat_rate
    end
  end

  describe '#vat_ratio' do
    it 'returns the variant vat_ratio' do
      expect(@variant.vat_ratio).to eq (1 + @variant.vat_rate / 100)
    end
  end

  describe '#published' do
    it 'returns all published variants' do
      published_variant = create(:variant, published: true)
      expect(Glysellin::Variant.published).to include(published_variant)
    end

    it 'does\'t return unpublished variants' do
      unpublished_variant = create(:variant, published: false)
      expect(Glysellin::Variant.published).not_to include(unpublished_variant)
    end
  end

  describe '#description' do
    it 'returns the associated sellable\'s description when a sellable is set' do
      allow(@variant).to receive(:sellable) { double(description: 'text') }
      expect(@variant.description).to eq('text')
    end

    it 'returns an empty string when no sellable is set' do
      @variant.sellable = nil
      expect(@variant.description).to eq ''
    end
  end
end
