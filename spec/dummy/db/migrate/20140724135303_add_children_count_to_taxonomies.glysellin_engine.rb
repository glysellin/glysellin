# This migration comes from glysellin_engine (originally 20140414123220)
class AddChildrenCountToTaxonomies < ActiveRecord::Migration
  def up
    add_column :glysellin_taxonomies, :children_count, :integer, default: 0

    Glysellin::Taxonomy.find_each do |taxonomy|
      Glysellin::Taxonomy.reset_counters(taxonomy.id, :children)
    end
  end

  def down
    remove_column :glysellin_taxonomies, :children_count
  end
end
