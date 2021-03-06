module Glysellin
  class Address < ActiveRecord::Base
    self.table_name = 'glysellin_addresses'

    store :additional_fields, :accessors => Glysellin.additional_address_fields

    belongs_to :shipped_addressable, polymorphic: true
    belongs_to :billed_addressable, polymorphic: true

    def name
      [full_name, company_name].map(&:presence).compact.join(' ')
    end

    def full_name
      [first_name, last_name].map(&:presence).compact.join(' ')
    end

    def location_string
      [zip, city, country].map(&:presence).compact.join(', ')
    end
  end
end
