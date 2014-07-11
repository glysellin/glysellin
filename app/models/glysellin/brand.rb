module Glysellin
  class Brand < ActiveRecord::Base
    self.table_name = "glysellin_brands"

    has_many :sellables

    has_attached_file :image, styles: {
      thumb: '150x150#'
    }

    validates :name, presence: true

    def self.order_and_print
      order('glysellin_brands.name ASC').map do |brand|
        ["#{ brand.name } (#{ brand.sellables_count } produit(s))", brand.id]
      end
    end
  end
end