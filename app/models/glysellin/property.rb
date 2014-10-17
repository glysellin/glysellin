module Glysellin
  class Property < ActiveRecord::Base
    self.table_name = 'glysellin_properties'

    include Glysellin::VariantCacheable

    has_many :variant_properties, class_name: 'Glysellin::VariantProperty',
                                  dependent: :destroy, inverse_of: :variant

    has_many :variants, class_name: 'Glysellin::Variant',
                        through: :variant_properties

    has_many :sellables, through: :variants
    belongs_to :property_type, class_name: 'Glysellin::PropertyType'

    validates :value, :barcode_ref, presence: true
  end
end