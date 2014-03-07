module Glysellin
  class PropertyType < ActiveRecord::Base
    self.table_name = 'glysellin_property_types'

    has_many :properties, class_name: 'Glysellin::Property'
    accepts_nested_attributes_for :properties, allow_destroy: true
  end
end