require "spec_helper"

describe Glysellin::Stock do
  it { should belong_to(:store) }
  it { should belong_to(:variant) }

  it { should validate_presence_of(:count) }
  it { should validate_numericality_of(:count) }
end