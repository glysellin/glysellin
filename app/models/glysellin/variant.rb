# require 'friendly_id'

# module Glysellin
#   class Variant < ActiveRecord::Base
#     self.table_name = 'glysellin_variants'

#     include Glysellin::Sellable::Mixin

#     extend FriendlyId
#     friendly_id :name, use: :slugged

#     belongs_to :sellable, class_name: "Glysellin::Sellable",
#       inverse_of: :variants, counter_cache: true

#     before_validation :ensure_name

#     delegate :vat_rate, :vat_ratio, :weight, to: :sellable

#     scope :published, -> { where(published: true) }

#     def description
#       sellable ? sellable.description : ''
#     end

#     private

#     def ensure_name
#       return if name.presence || variant_properties.length == 0
#       self.name = custom_name
#     end

#     def price
#       read_attribute(:price) || (sellable && sellable.price)
#     end

#     def eot_price
#       read_attribute(:eot_price) || (sellable && sellable.eot_price)
#     end

#     def custom_name
#       if variant_properties.any?
#         properties_names = variant_properties.map(&:property).flatten.map(&:value).join(', ')
#         [sellable.name, properties_names].join(' — ')
#       else
#         [sellable.name, name].join(' — ')
#       end
#     end
#   end
# end
