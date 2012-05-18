module Glysellin
  class Taxonomy < ActiveRecord::Base
    include ModelInstanceHelperMethods
    
    self.table_name = 'glysellin_taxonomies'
    
    attr_accessible :name
    
    has_and_belongs_to_many :products, :join_table => 'glysellin_products_taxonomies'
    
    has_many :sub_taxonomies, :class_name => 'Taxonomy'
    belongs_to :parent_taxonomy, :foreign_key => 'parent_taxonomy_id', :class_name => 'Taxonomy'
    
    before_validation do
      self.slug = self.name.to_slug
    end
  end
end
