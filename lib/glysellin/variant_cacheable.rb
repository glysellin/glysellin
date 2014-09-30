module Glysellin
  module VariantCacheable
    extend ActiveSupport::Concern

    included do
      after_save :refresh_variants_long_name
    end

    def variants(*args)
      raise "Any class that includes Glysellin::VariantCacheable must define " \
            "the #variants method which would return an " \
            "ActiveRecord::Relation containing the variants whose long_name " \
            "should be refreshed."
    end

    def refresh_variants_long_name
      refreshable_variants = variants.includes(
        variant_properties: :property,
        sellable: { taxonomy: { parent: :parent } }
      )

      refreshable_variants.each do |variant|
        variant.refresh_long_name
        variant.save(validate: false)
      end
    end
  end
end
