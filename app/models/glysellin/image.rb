module Glysellin
  class Image < ActiveRecord::Base
    self.table_name = 'glysellin_images'

    belongs_to :imageable, polymorphic: true

    has_attached_file :image, styles: Glysellin.product_images_styles

    validates_attachment :image, content_type: {
      content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
    }
  end
end
