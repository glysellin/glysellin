require "spec_helper"

describe Glysellin::Store do
  it { should have_many(:stocks) }
  it { should have_many(:variants) }
  it { should have_many(:orders) }

  it { should validate_presence_of(:name) }

  let(:store) { create(:store) }

  describe '#in_stock?' do
    it 'returns true if sellable is unlimited' do
      sellable = create(:sellable, unlimited_stock: true)
      variant = sellable.variants.sample
      variant.stores << store

      expect(store.in_stock?(variant)).to eq true
    end

    it 'returns true if sellable is not unlimited but available' do
      sellable = create(:sellable, unlimited_stock: false)
      variant = sellable.variants.sample
      variant.stores << store

      stock = variant.stocks.where(store_id: store.id).first
      stock.count = 10
      stock.save!

      expect(store.in_stock?(variant)).to eq true
    end

    it 'returns false if sellable is not unlimited but available' do
      sellable = create(:sellable, unlimited_stock: false)
      variant = sellable.variants.sample
      variant.stores << store

      stock = variant.stocks.where(store_id: store.id).first
      stock.count = 0
      stock.save!

      expect(store.in_stock?(variant)).to eq false
    end
  end

  describe '#available?' do
    it 'returns true if sellable is unlimited' do
      sellable = create(:sellable, unlimited_stock: true)
      variant = sellable.variants.sample
      variant.stores << store

      expect(store.available?(variant, 10)).to eq true
    end

    it 'returns true if sellable is not unlimited but available quantity' do
      sellable = create(:sellable, unlimited_stock: false)
      variant = sellable.variants.sample
      variant.stores << store

      stock = variant.stocks.where(store_id: store.id).first
      stock.count = 10
      stock.save!

      expect(store.available?(variant, 10)).to eq true
    end

    it 'returns false if sellable is not unlimited but available quantity' do
      sellable = create(:sellable, unlimited_stock: false)
      variant = sellable.variants.sample
      variant.stores << store

      stock = variant.stocks.where(store_id: store.id).first
      stock.count = 10
      stock.save!

      expect(store.available?(variant, 11)).to eq false
    end
  end
end