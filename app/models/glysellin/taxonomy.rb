module Glysellin
  class Taxonomy < ActiveRecord::Base
    self.table_name = 'glysellin_taxonomies'

    scope :roots, -> { where(parent_id: nil) }
    scope :selectable, -> { where(children_count: 0) }
    scope :ordered, -> do
      joins(
        'INNER JOIN glysellin_taxonomies parent_taxonomy ' +
        'ON glysellin_taxonomies.parent_id = parent_taxonomy.id ' +
        'INNER JOIN glysellin_taxonomies grand_parent_taxonomy ' +
        'ON parent_taxonomy.parent_id = grand_parent_taxonomy.id'
       ).order(
        'grand_parent_taxonomy.name DESC, parent_taxonomy.name ASC, ' +
        'glysellin_taxonomies.name ASC'
      )
    end

    has_many :sellables, dependent: :nullify
    has_many :children, class_name: 'Glysellin::Taxonomy',
      foreign_key: 'parent_id', dependent: :destroy

    has_many :taxonomies_store_clients
    has_many :store_clients, through: :taxonomies_store_clients, class_name: 'Glysellin::StoreClient'

    belongs_to :parent, class_name: 'Glysellin::Taxonomy',
      counter_cache: :children_count

    validates :name, presence: true

    before_save :fill_path
    after_save :update_children_path

    def update_children_path
      children.each(&:update_path)
    end

    def fill_path
      self.full_path = path_string
    end

    def update_path
      update_attributes(full_path: path_string)
    end

    def path_string
      path.map(&:name).join(' - ')
    end

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
      self.includes(:sellables).ordered.map do |b|
        ["#{ b.name } (#{ b.sellables.size } produit(s))", b.id]
      end
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
