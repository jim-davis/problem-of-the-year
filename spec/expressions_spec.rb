require "Rspec"
require "expressions"

describe Digit do
  it "has depth 0" do
    d = Digit.new("0")
    expect(d.depth).to eq(0)
  end
end

describe MonadicExpression do
  it "has depth 1 greater than depth of its operand" do
    op =  double("operand")
    d = 7
    allow(op).to receive(:depth) {d}
    expr = MonadicExpression.new(nil,  op)
    
    expect(expr.depth).to eq(d + 1)
  end
end

describe BinaryExpression do
  it "has depth 1 greater than max depth of its two operans" do
    op1 =  double("operand")
    allow(op1).to receive(:depth) {2}
    op2 =  double("operand")
    allow(op2).to receive(:depth) {3}
    expr = BinaryExpression.new(nil,  op1, op2)
    expect(expr.depth).to eq(4)
  end
end
