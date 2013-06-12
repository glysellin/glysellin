module Glysellin
  module Sellable
    module Simple
      extend ActiveSupport::Concern

      included do
        has_one :variant, as: :sellable, class_name: "Glysellin::Variant",
          inverse_of: :sellable, dependent: :destroy
        accepts_nested_attributes_for :variant, allow_destroy: true,
          reject_if: :all_blank
        attr_accessible :variant_attributes

        # Published sellables are the ones that have at least one variant
        # published.
        #
        # This behaviour can be overriden inside the sellable's model if the
        # scope is declared after the `acts_as_sellable` call
        scope :published, -> {
          includes(:variant).where( glysellin_variants: { published: true })
        }
      end

      # Fetches variant wrapping it in an ActiveRecord::Relation object to
      # make behavior consistent with sellables in Multi mode
      def variants
        Variant.where(sellable_id: id, sellable_type: self.class.to_s)
      end
    end
  end
end