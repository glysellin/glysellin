module Glysellin
  module ShippingCarrier
    module Helpers
      module CountryWeightTable
        extend ActiveSupport::Concern

        module ClassMethods
          attr_accessor :path_to_data

          def country_weight_table_file path
            loadable_paths = [File.join(ENV['PWD'], 'lib')] + $LOAD_PATH
            # Try to find table file in load path
            loadable_paths.each do |loadable_path|
              file = File.join(loadable_path, '..', 'db', 'seeds', 'shipping_carrier', 'rates', path)
              if File.exists?(file)
                @path_to_data = file
                return
              end
            end
          end

          def available_for?(address)
            if country = address.try(:country)
              prices_data.any? do |data|
                data[:countries].include?(country)
              end
            end
          end

          def prices_data
            csv = CSV.parse(File.read(path_to_data))
            headers = csv.shift

            data = headers[1..-1].map do |c|
              {
                countries: c.split(",").map(&:strip),
                prices: {}
              }
            end

            csv.each do |row|
              max_weight = row.shift.to_f

              row.each_with_index do |cell, index|
                data[index][:prices][max_weight] = cell.try(:to_f)
              end
            end

            data
          end
        end

        def price_for_weight_and_country
          weight = @order.total_weight
          country = @order.use_another_address_for_shipping ?
            @order.shipping_address.country : @order.billing_address.country

          zone = self.class.prices_data.find do |zone|
            zone[:countries].include?(country)
          end

          if zone
            weight_price = zone[:prices].find do |max_weight, price|
              weight < max_weight
            end

            weight_price.last if weight_price
          end
        end
      end
    end
  end
end
