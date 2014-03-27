module Glysellin
  class AddressSerializer < ActiveModel::Serializer
    attributes :id, :company_name, :vat_number, :first_name, :last_name, :address,
      :address_details, :zip, :city, :country, :tel, :fax, :additional_fields
  end
end
