module Glysellin
  module Sellable
    module Multi
      extend ActiveSupport::Concern

      included do
        has_many :variants, as: :sellable, class_name: "Glysellin::Variant",
          inverse_of: :sellable, dependent: :destroy
        accepts_nested_attributes_for :variants, allow_destroy: true,
          reject_if: :all_blank
        attr_accessible :variants_attributes

        # Published sellables are the ones that have at least one variant
        # published.
        #
        # This behaviour can be overriden inside the sellable's model if the
        # scope is declared after the `acts_as_sellable` call
        scope :published, -> {
          includes(:variants).where(glysellin_variants: { published: true })
        }
      end
    end
  end
end