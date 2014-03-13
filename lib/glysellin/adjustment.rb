module Glysellin
  module Adjustment
    def to_adjustment order
      { name: name, value: adjustment_value_for(order), adjustment: self }
    end
  end
end
