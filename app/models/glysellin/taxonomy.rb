module Glysellin
  class Taxonomy < ActiveRecord::Base
    self.table_name = 'glysellin_taxonomies'

    scope :roots, -> { where(parent_id: nil) }
    scope :selectable, -> { where(children_count: 0) }

    has_many :sellables, dependent: :nullify

    has_many :children, class_name: 'Glysellin::Taxonomy',
      foreign_key: 'parent_id', dependent: :destroy

    belongs_to :parent, class_name: 'Glysellin::Taxonomy',
      counter_cache: :children_count

    validates :name, presence: true

    def deep_sellables_count
      count = sellables.size
      children.each { |c| count += c.deep_sellables_count }
      count
    end

    def deep_children_ids
      ids = children.pluck :id
      children.each { |c| ids.push c.deep_children_ids }
      ids.flatten.compact
    end

    def self.order_and_print
      self.includes(:sellables).order('name asc').map { |b| ["#{b.name} (#{b.sellables.size} produit(s))", b.id] }
    end

    def path
      taxonomy_tree_for = ->(taxonomy) {
        tree = [taxonomy]

        if taxonomy.parent_id
          (taxonomy_tree_for.call(taxonomy.parent) + tree)
        else
          tree
        end
      }

      taxonomy_tree_for.call(self)
    end

    def full_name
      path.join(" > ")
    end
  end
end
