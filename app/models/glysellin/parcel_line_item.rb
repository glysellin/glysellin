module Glysellin
  class ParcelLineItem < ActiveRecord::Base
    self.table_name = 'glysellin_parcel_line_items'

    belongs_to :parcel
    belongs_to :line_item

    validates :parcel, :line_item, :quantity, presence: true

    scope :ordered, -> { order('glysellin_parcel_line_items.line_item_id ASC') }
  end
end
