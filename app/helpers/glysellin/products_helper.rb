module Glysellin
  module ProductsHelper
    def variants_options_for sellable
      # Prepare ou arguments arrays
      all_variants, disabled_variants = [], []
      # Iterate on each variant to find which are enabled and disabled
      sellable.variants.each do |variant|
        next unless variant.published?
        if current_store.in_stock?(variant)
          name = variant.name
        else
          disabled_variants << variant.id
          name = variant.name +
            " (#{ t('glysellin.labels.sellables.out_of_stock') })"
        end

        all_variants << ["#{name} (#{number_to_currency(variant.price)})", variant.id]
      end

      options_for_select(all_variants, disabled: disabled_variants)
    end
  end
end
