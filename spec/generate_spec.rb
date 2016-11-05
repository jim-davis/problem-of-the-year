require "Rspec"
require "generate"
require "expressions"

describe "#monadic_expressions_over" do
  it "the unit tests assume there are four monadic operators" do
    expect(MONADIC_OPERATORS.count).to eq(4) # Fact, Sqrt, Decimalize, RepeatingDecimal
  end

  it "generates an expression of depth 1" do
    expect(monadic_expressions_over(Digit.new(0)).map{|expr| expr.depth}.max).to eq(1)
  end

  it "combines all monadic operators to depth 1" do
    expect(monadic_expressions_over(Digit.new(9)).length).to eq(4 + 1)

  end
end

describe "#binary_expressions_over" do
  it "generates every monadic operator applied to every binary operator" do
    expect(binary_expressions_over(Digit.new(1), Digit.new(2)).length).to eq(3 * BINARY_OPERATORS.length)
  end
  it "generates an array" do
    r = binary_expressions_over(Digit.new(1), Digit.new(2))
    expect(r.kind_of?(Array)).to eq(true)
  end
  it "generates an array of expressions" do
    r = binary_expressions_over(Digit.new(1), Digit.new(2))
    expect(r[0].kind_of?(Expression)).to eq(true)
  end
  describe "when given array of ops" do
    it "combines the two arrays" do
      op1 = [Digit.new(1), Digit.new(2)]
      op2 = [Digit.new(3), Digit.new(4)]
      r = binary_expressions_over(op1, op2)
      puts "#{r}"
      expect(r.length).to eq(4 * 6 * 3)
      expect(r.kind_of?(Array)).to eq(true)
      expect(r[0].kind_of?(Expression)).to eq(true)
    end
  end
end

