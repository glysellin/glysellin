# This migration comes from glysellin_engine (originally 20140711124002)
class AddSellablesCountToGlysellinTaxonomies < ActiveRecord::Migration
  def up
    add_column :glysellin_taxonomies, :sellables_count, :integer, default: 0

    Glysellin::Taxonomy.pluck(:id).each do |taxonomy_id|
      Glysellin::Taxonomy.reset_counters(taxonomy_id, :sellables)
    end
  end

  def down
    remove_column :glysellin_taxonomies, :sellables_count
  end
end
