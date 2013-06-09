module Glysellin
  module PropertyFinder
    def method_missing method, *args
      if (prop = find { |prop| prop.type.name == method.to_s })
        prop.value
      elsif Glysellin::ProductPropertyType.select('1').find_by_name(method)
        false
      else
        super
      end
    end
  end
end