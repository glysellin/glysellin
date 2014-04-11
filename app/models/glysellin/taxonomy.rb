module Glysellin
  class Taxonomy < ActiveRecord::Base
    self.table_name = 'glysellin_taxonomies'

    scope :roots, -> { where(parent_id: nil) }

    has_many :sellables, dependent: :nullify
    has_many :children, class_name: 'Glysellin::Taxonomy', foreign_key: 'parent_id', dependent: :destroy
    belongs_to :parent, class_name: 'Glysellin::Taxonomy'

    validates :name, presence: true
    validates :barcode_ref, presence: true

    def self.order_and_print
      self.includes(:sellables).order('name asc').map { |b| ["#{b.name} (#{b.sellables.size} produit(s))", b.id] }
    end

    def path
      path = [self]
      p = parent

      while true
        break unless p.present?
        path.push p
        p = p.parent
      end

      path.reverse
    end
  end
end
