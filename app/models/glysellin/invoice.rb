module Glysellin
  class Invoice < ActiveRecord::Base
    self.table_name = 'glysellin_invoices'

    belongs_to :order

    validates :number, :order, presence: true

    before_validation do
      self.number ||= Glysellin.invoice_number_generator.call(order)
    end

    def self.export(format = :xls)
      ExportInvoice.new(format, all).file_path
    end
  end
end
