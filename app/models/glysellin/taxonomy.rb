module Glysellin
  class Taxonomy < ActiveRecord::Base
    self.table_name = 'glysellin_taxonomies'

    extend FriendlyId
    friendly_id :name, use: [:slugged, :history, :finders]

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

    private

    def should_generate_new_friendly_id?
      slug.blank? || name_changed?
    end
  end
end
