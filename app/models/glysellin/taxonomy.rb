module Glysellin
  class Taxonomy < ActiveRecord::Base
    self.table_name = "glysellin_taxonomies"
    has_many :products, class_name: 'Glysellin::Sellable', dependent: :nullify

    def self.order_and_print
      self.includes(:products).order('name asc').map { |b| ["#{b.name} (#{b.products.size} produit(s))", b.id] }
    end
  end
end