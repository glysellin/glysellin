shared_examples "an adjustment" do
  it "has a #name method" do
    expect(subject.instance_methods).to include(:name)
  end

  it "has an #adjustment_value_for method" do
    expect(subject.instance_methods).to include(:adjustment_value_for)
  end

  describe "#to_adjustment" do
    it "returns a hash containing a name, a value and an adjustment object" do
      object = subject.new
      allow(object).to receive(:name) { "adjustment" }
      allow(object).to receive(:adjustment_value_for) { 5 }
      expect(object.to_adjustment).to eq(
        name: "adjustment", value: 5, adjustment: object
      )
    end
  end
end