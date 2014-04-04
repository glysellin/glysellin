# This migration comes from glysellin_engine (originally 20140313152259)
class ChangeSlugToIdentifierInPaymentMethods < ActiveRecord::Migration
  def change
    rename_column :glysellin_payment_methods, :slug, :identifier
  end
end
