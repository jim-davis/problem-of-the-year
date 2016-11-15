require "generate"


describe "#monadic_expressions_over" do
  it "the unit tests assume there are five monadic operators" do
    expect(MONADIC_OPERATORS.count).to eq(5) # Fact, Sqrt, Decimalize, RepeatingDecimal, PrefixMinus
  end

  it "generates an expression of depth 1" do
    expect(monadic_expressions_over(Digit.new(0)).map{|expr| expr.depth}.max).to eq(1)
  end

  it "combines all monadic operators to depth 1" do
    # Fixme this test works because we know that digit 9 is the only one to which all monadic operators
    # may be applied.
    expect(monadic_expressions_over(Digit.new(9)).length).to eq(5 + 1)
  end
end

describe "#expressions_over" do
  it "generates an array" do
    expect(expressions_over([Digit.new(1)], [Digit.new(2)])).to be_kind_of(Array)
  end
  it "generates an array of expressions" do
    r = expressions_over([Digit.new(1)], [Digit.new(2)])
    expect(r[0].kind_of?(Expression)).to eq(true)
  end
end

