class AddLongNameToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :long_name, :text
  end
end
