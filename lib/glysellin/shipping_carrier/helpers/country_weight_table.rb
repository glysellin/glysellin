module Glysellin
  module ShippingCarrier
    module Helpers
      module CountryWeightTable
        extend ActiveSupport::Concern

        module ClassMethods
          attr_accessor :path

          def country_weight_table_file(path)
            @path = path
          end

          def path_to_data
            loadable_paths = [Rails.root.join('lib')] + $LOAD_PATH

            # Try to find table file in load path
            loadable_paths.each do |loadable_path|
              file = File.join(loadable_path, '..', 'db', 'seeds', 'shipping_carrier', 'rates', path)
              if File.exists?(file)
                return file
              end
            end

            nil
          end

          def available_for?(address)
            prices_data.key?(address.try(:country))
          end

          def prices_data
            csv = CSV.parse(File.read(path_to_data))
            headers = csv.shift

            headers.each_with_index.each_with_object({}) do |(countries, index), hash|
              next if index == 0

              countries.split(",").each do |country|
                country_code = country.strip
                hash[country_code] = {}

                csv.each do |row|
                  max_weight = row.first.to_f
                  price = row[index].try(:to_f)
                  hash[country_code][max_weight] = price
                end
              end
            end
          end
        end

        def price_for_weight_and_country
          weight = order.total_weight
          country = order.shipping_address.country
          country_prices = self.class.prices_data[country]

          return unless country_prices

          weight_price = country_prices.each do |max_weight, price|
            return price if weight < max_weight
          end

          # Return nil if no price was found
          nil
        end
      end
    end
  end
end
