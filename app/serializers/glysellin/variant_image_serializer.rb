module Glysellin
  class VariantImageSerializer < ActiveModel::Serializer
    attributes :id, :thumb, :original, :content

    def thumb
      object.image.url(:thumb)
    end

    def content
      object.image.url(:content)
    end

    def original
      object.image.url(:original)
    end
  end
end
