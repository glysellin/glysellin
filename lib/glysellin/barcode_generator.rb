module Glysellin
  class BarcodeGenerator
    include ActiveModel::Validations

    attr_reader :variant

    def initialize(variant)
      @variant = variant
    end

    def generate
      last = Glysellin::Variant.order('glysellin_variants.sku DESC').first
      (last && last.sku.to_i + 1) || 1
    end
  end
end