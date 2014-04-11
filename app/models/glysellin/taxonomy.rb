module Glysellin
  class Taxonomy < ActiveRecord::Base
    self.table_name = 'glysellin_taxonomies'

    has_many :products, class_name: 'Glysellin::Sellable', dependent: :nullify
    has_many :children, class_name: 'Glysellin::Taxonomy', foreign_key: 'parent_id', dependent: :destroy
    belongs_to :parent, class_name: 'Glysellin::Taxonomy'

    validates :name, presence: true
    validates :barcode_ref, presence: true

    def self.order_and_print
      self.includes(:products).order('name asc').map { |b| ["#{b.name} (#{b.products.size} produit(s))", b.id] }
    end
  end
end