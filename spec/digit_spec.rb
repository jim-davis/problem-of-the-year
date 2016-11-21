require "digit"

describe Digit do
  it "has value that is number" do
    d = Digit.new(9)
    expect(d.value).to be_a(Integer)
    expect(d.value).to eq(9)
  end
  it "has depth 0" do
    d = Digit.new("0")
    expect(d.depth).to eq(0)
  end
  describe "#to_s" do
    it "is just the value" do
      expect(Digit.new("0").to_s).to eq("0")
    end
  end
  describe "#eql?" do
    it "is eql? to another Digit with same value" do
      d1 =  Digit.new(9)
      expect(d1.eql?(Digit.new(9))).to be(true)
    end
  end
end

