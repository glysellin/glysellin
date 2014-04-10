module Glysellin
  class Parcel < ActiveRecord::Base
    belongs_to :sendable, polymorphic: true

    has_many :line_items

    validates_presence_of :name
  end
end