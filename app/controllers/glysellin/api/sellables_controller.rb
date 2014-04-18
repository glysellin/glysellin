module Glysellin
  module Api
    class SellablesController < BaseController
      def index
        @q = sellables_with_includes.search(params)
        render json: @q.result, each_serializer: Glysellin::SellableSerializer
      end

      def show
        @sellable = sellables_with_includes.where(id: params[:id]).first
        render json: @sellable, each_serializer: Glysellin::SellableSerializer
      end

      private

      def sellables_with_includes
        Glysellin::Sellable.includes(variants: [:stocks, variant_properties: [property: :property_type]])
      end
    end
  end
end
