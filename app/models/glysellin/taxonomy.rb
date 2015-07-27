module Glysellin
  class Taxonomy < ActiveRecord::Base
    self.table_name = 'glysellin_taxonomies'

    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

    include Glysellin::VariantCacheable

    scope :roots, -> { where(parent_id: nil) }
    scope :ordered, -> { order(name: :asc) }

    has_many :sellables, dependent: :nullify
    has_many :children, class_name: 'Glysellin::Taxonomy',
      foreign_key: 'parent_id', dependent: :destroy

    belongs_to :parent, class_name: 'Glysellin::Taxonomy',
      counter_cache: :children_count

    validates :name, presence: true

    before_save :fill_path
    after_save :update_children_path

    def variants
      Glysellin::Variant.joins(sellable: { taxonomy: { parent: :parent } })
        .where(
          "glysellin_taxonomies.id = :id OR " \
          "parents_glysellin_taxonomies.id = :id OR " \
          "parents_glysellin_taxonomies_2.id = :id",
          id: id
        )
    end

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

    def slug_candidates
      [
        :name,
        :path_string
      ]
    end
  end
end
