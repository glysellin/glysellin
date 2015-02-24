module Glysellin
  class Parcel < ActiveRecord::Base
    self.table_name = 'glysellin_parcels'

    belongs_to :sendable, polymorphic: true, touch: true

    has_many :parcel_line_items, inverse_of: :parcel, dependent: :destroy
    has_many :line_items, through: :parcel_line_items

    validates :name, :parcel_line_items, presence: true
  end
end
