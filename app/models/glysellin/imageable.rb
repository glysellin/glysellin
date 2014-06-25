module Glysellin
  class Imageable < ActiveRecord::Base
    self.table_name = 'glysellin_imageables'

    belongs_to :imageable_owner, polymorphic: true
    belongs_to :image
  end
end