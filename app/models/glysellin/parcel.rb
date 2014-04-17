module Glysellin
  class Parcel < ActiveRecord::Base
    self.table_name = 'glysellin_parcels'

    belongs_to :sendable, polymorphic: true

    has_many :line_items, as: :container
    accepts_nested_attributes_for :line_items, allow_destroy: true,
      reject_if: :all_blank

    validates_presence_of :name, :line_items
  end
end