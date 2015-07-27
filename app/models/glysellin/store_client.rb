module Glysellin
  class StoreClient < ActiveRecord::Base
    self.table_name = 'glysellin_store_clients'

    validates :name, :key, presence: true

    before_validation :ensure_key
    belongs_to :store

    def ensure_key
      self.key ||= rand(100**10).to_s(36)
    end
  end
end
