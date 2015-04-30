module Glysellin
  class Image < ActiveRecord::Base
    self.table_name = 'glysellin_images'

    belongs_to :imageable, polymorphic: true
    has_attached_file :file, styles: Glysellin.product_images_styles

    validates_attachment :file, content_type: {
      content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
    }

    def image_url=(url)
      self.file = URI.parse(url)
    end

    def image_url(style = :thumb)
      file.present? && file.url(style)
    end
  end
end
