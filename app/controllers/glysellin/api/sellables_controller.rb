module Glysellin
  module Api
    class SellablesController < BaseController

      def show
        @sellable = sellables_with_includes.where(id: params[:id]).first
        render json: @sellable, each_serializer: Glysellin::SellableSerializer
      end

      private

      def sellables_with_includes
        Glysellin::Sellable.includes(:variant_images, variants: [:stocks, :variant_images, variant_properties: [property: :property_type]])
      end
    end
  end
end
