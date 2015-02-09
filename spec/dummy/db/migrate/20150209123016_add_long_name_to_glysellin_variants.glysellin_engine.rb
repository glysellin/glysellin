# This migration comes from glysellin_engine (originally 20140924131756)
class AddLongNameToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :long_name, :text
  end
end
