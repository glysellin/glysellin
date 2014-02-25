module Glysellin
  class Brand < ActiveRecord::Base
    self.table_name = "glysellin_brands"

    has_many :products, class_name: 'Glysellin::Sellable'
    has_attached_file :image, styles: {thumb: '150x150#'}

    validates_presence_of :name

    def self.order_and_print
      self.includes(:products).order('name asc').map { |b| ["#{b.name} (#{b.products.size} produit(s))", b.id] }
    end
  end
end