module Glysellin
  class ProductProperty < ActiveRecord::Base
    self.table_name = 'glysellin_product_properties'

    belongs_to :variant, class_name: "Glysellin::Variant",
      inverse_of: :properties

    belongs_to :type, class_name: 'Glysellin::ProductPropertyType',
      inverse_of: :properties

    # validate :check_uniqueness_of_type

    validates_presence_of :type, :value
    # validates_associated :type, :if => Proc.new { |type| !self.variant.properties.map(&:type).include?(type) }

    private

    def name
      type && type.name
    end

    def check_uniqueness_of_type
      if self.variant.properties.map(&:type).include? self.type
        errors.add(:type, I18n.t("glysellin.controllers.errors.double_property"))
      end
    end
  end
end