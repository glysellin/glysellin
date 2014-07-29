require "spec_helper"

describe Glysellin::Brand do
  it { should have_many(:sellables) }
  it { should have_attached_file(:image) }

  it { should validate_presence_of(:name) }

  describe '.ordered' do
    it 'returns ordered brands scope' do
      brand_1 = create(:brand, name: 'Nike')
      brand_2 = create(:brand, name: 'Pepe Jeans')
      brand_3 = create(:brand, name: 'Diesel')

      expect(Glysellin::Brand.ordered.map(&:id)).to eq [brand_3, brand_1, brand_2].map(&:id)
    end
  end

  describe '.order_and_print' do
    it 'returns ordered brands in custom mapping' do
      brand_1 = create(:brand, name: 'Nike')
      brand_2 = create(:brand, name: 'Pepe Jeans')
      brand_3 = create(:brand, name: 'Diesel')

      create(:sellable, brand: brand_1)
      create(:sellable, brand: brand_2)
      create(:sellable, brand: brand_2)
      create(:sellable, brand: brand_3)

      expect(Glysellin::Brand.order_and_print).to eq [
        ['Diesel (1 produit(s))',     brand_3.id],
        ['Nike (1 produit(s))',       brand_1.id],
        ['Pepe Jeans (2 produit(s))', brand_2.id]
      ]
    end
  end
end