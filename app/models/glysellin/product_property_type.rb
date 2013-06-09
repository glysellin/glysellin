module Glysellin
  class ProductPropertyType < ActiveRecord::Base
    self.table_name = 'glysellin_product_property_types'
    attr_accessible :name

    has_many :properties, class_name: "Glysellin::ProductProperty",
      foreign_key: 'type_id', inverse_of: :type

    def name
      "hoo"
    end
  end
end