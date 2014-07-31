module Glysellin
  class Image < ActiveRecord::Base
    self.table_name = 'glysellin_images'

    belongs_to :imageable, dependent: :destroy
    has_attached_file :image, styles: Glysellin.product_images_styles

    validates_attachment :image, content_type: {
      content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
    }

    def image_url=(url)
      self.image = URI.parse(url)
    end

    def image_url(style = :thumb)
      image? && image.url(style)
    end
  end
end
