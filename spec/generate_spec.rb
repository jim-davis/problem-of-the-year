require "Rspec"
require "generate"
require "expressions"

describe "#monadic_expressions_over" do
  it "generates an expression of depth 1" do
    expect(monadic_expressions_over(Digit.new(0)).map{|expr| expr.depth}.max).to eq(1)
  end

  it "combines all monadic operators to depth 1" do
    expect(monadic_expressions_over(Digit.new(1)).length).to eq(3)
  end
end
