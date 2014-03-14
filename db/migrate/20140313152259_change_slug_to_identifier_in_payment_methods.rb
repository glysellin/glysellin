class ChangeSlugToIdentifierInPaymentMethods < ActiveRecord::Migration
  def change
    rename_column :glysellin_payment_methods, :slug, :identifier
  end
end
