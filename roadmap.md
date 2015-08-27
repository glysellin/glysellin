# Roadmap refactoring :

Products :
  - Acts as sellable
  - Variant = acts_as_sellable
  - Sellable Group = has_variants

```ruby
class Variant < ActiveRecord::Base
  include Glysellin::Sellable::Mixin
end

class Product

end

```
