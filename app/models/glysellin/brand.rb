module Glysellin
  class Brand < ActiveRecord::Base
    self.table_name = "glysellin_brands"

    has_many :products

    has_attached_file :image,
      styles: {
        thumb: '150x150#'
      }
  end
end