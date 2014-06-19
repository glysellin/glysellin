module Glysellin
  module Imageable
    extend ActiveSupport::Concern

    included do
      has_many :images, as: :imageable, dependent: :destroy
    end

    def image_url=(url)
      self.images = [Glysellin::Image.new(image: URI.parse(url))]
    end

    def image_url
      images.first.image.url(:thumb) if images?
    end

    def images?
      images.length > 0
    end
  end
end
