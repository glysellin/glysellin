require 'spec_helper'

describe Glysellin::Sellable do
  it { should belong_to(:taxonomy) }
  it { should belong_to(:brand) }

  it { should have_many(:imageables) }
  it { should have_many(:images) }
  it { should have_many(:variants) }
  it { should have_many(:variant_images) }

  it { should validate_numericality_of(:vat_rate) }
  it { should validate_numericality_of(:eot_price) }
  it { should validate_numericality_of(:price) }

  let(:sellable) { create(:sellable) }

  describe '.published' do
    before do
      @published_sellable = create(:sellable)
      @unpublished_sellable = create(:sellable)
      @unpublished_sellable.variants.each { |variant| variant.update_attribute(:published, false) }
    end

    it 'returns all products that have published variants' do
      expect(Glysellin::Sellable.published).to include(@published_sellable)
    end

    it 'does not return products with no published variants' do
      expect(Glysellin::Sellable.published).not_to include(@unpublished_sellable)
    end
  end

  describe '.sorted' do
    it 'returns sellables sorted from grandparent to kids' do
      gparent1 = create(:taxonomy, name: '2014')
      gparent2 = create(:taxonomy, name: '2012')

      parent1 = create(:taxonomy, name: 'Tshirt Good', parent: gparent1)
      parent2 = create(:taxonomy, name: 'Tshirt Best', parent: gparent1)
      parent3 = create(:taxonomy, name: 'Tshirt Awesome', parent: gparent2)

      kid1 = create(:taxonomy, parent: parent2, name: 'Marque 1')
      kid2 = create(:taxonomy, parent: parent1, name: 'Marque 2')
      kid3 = create(:taxonomy, parent: parent3, name: 'Marque 3')

      sellable1 = create(:sellable, taxonomy: kid1)
      sellable2 = create(:sellable, taxonomy: kid2)
      sellable3 = create(:sellable, taxonomy: kid2)

      expect(Glysellin::Sellable.sorted).to eq [
          sellable1,
          sellable2,
          sellable3
        ]
    end
  end

  describe '#vat_rate' do
    it 'returns the :vat_rate column\'s value when set' do
      sellable.vat_rate = 20
      expect(sellable.vat_rate).to eq 20
    end

    it 'returns the global default VAT rate when column is null' do
      Glysellin.default_vat_rate = 10
      expect(sellable.vat_rate).to eq 10
    end
  end

  describe '#vat_ratio' do
    it 'returns the ratio to multiply prices with to obtain the total price' do
      sellable.vat_rate = 5
      expect(sellable.vat_ratio).to eq 1.05
    end
  end

  describe '#published_variants' do
    it 'returns the associated variants that are published' do
      variant_1 = create(:variant)
      variant_2 = create(:variant)
      variant_3 = create(:variant, published: false)

      sellable.variants << variant_1
      sellable.variants << variant_2

      expect(sellable.published_variants).to include variant_1
      expect(sellable.published_variants).to include variant_2
      expect(sellable.published_variants).not_to include variant_3
    end
  end
end
