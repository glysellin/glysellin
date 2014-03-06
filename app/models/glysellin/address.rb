module Glysellin
  class Address < ActiveRecord::Base
    self.table_name = 'glysellin_addresses'

    # Additional fields can be added through Glysellin.config.additional_address_fields in an app initializer
    store :additional_fields, :accessors => Glysellin.additional_address_fields
    # Relations
    #
    # And address can be used as shipping or billing address
    belongs_to :shipped_addressable, polymorphic: true
    belongs_to :billed_addressable, polymorphic: true

    # Validations
    #
    # Validates presence of the fields defined in the config file or the glysellin initializer
    validates_presence_of :company_name, unless: :first_name
    validates_presence_of :first_name, :last_name, unless: :company_name

    def same_as?(other)
      clone_attributes == other.clone_attributes
    end

    def clone_attributes
      clone.attributes.reject do |key, value|
        key = key.to_s
        %w(id created_at updated_at).include?(key) ||
          key.match(/_addressable_(type|id)$/)
      end
    end

    def full_name
      [first_name, last_name, company_name].reduce([]) do |name, str|
        name << (str || "")
      end.join(" ")
    end
  end
end
