require "spec_helper"

describe Glysellin::Store do
  it { should have_many(:stocks) }
  it { should have_many(:variants) }
end