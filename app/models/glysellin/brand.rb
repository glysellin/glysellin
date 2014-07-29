module Glysellin
  class Brand < ActiveRecord::Base
    self.table_name = "glysellin_brands"

    scope :ordered, -> { order('glysellin_brands.name ASC') }

    has_many :sellables, dependent: :nullify
    has_attached_file :image, styles: {
      thumb: '150x150#'
    }

    validates :name, presence: true

    def self.order_and_print
      ordered.map do |brand|
        ["#{ brand.name } (#{ brand.sellables_count } produit(s))", brand.id]
      end
    end
  end
end