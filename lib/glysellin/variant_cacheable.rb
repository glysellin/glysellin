module Glysellin
  module VariantCacheable
    extend ActiveSupport::Concern

    included do
      
    end

    def variants(*args)
      raise "Any class that includes Glysellin::VariantCacheable must define " \
            "the #variants method which would return an " \
            "ActiveRecord::Relation containing the variants whose long_name " \
            "should be refreshed."
    end
  end
end
