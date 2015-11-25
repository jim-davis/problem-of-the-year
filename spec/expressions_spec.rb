require "Rspec"
require "expressions"

describe Digit do
  it "has depth 0" do
    d = Digit.new("0")
    expect(d.depth).to eq(0)
  end
  describe "#to_s" do
    it "is just the value" do
      expect(Digit.new("0").to_s).to eq("0")
    end
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
  describe "#opCount" do
    it "is 1 plus opCount of the operand" do
      op1 =  double("operand")
      allow(op1).to receive(:opCount) {2}
      operator = double("operator")
      allow(operator).to receive(:opCount) {1}
      expr = MonadicExpression.new(operator,  op1)
      expect(expr.opCount).to eq(1+ 2)
    end
  end

end

describe BinaryExpression do
  it "has depth 1 greater than max depth of its two operands" do
    op1 =  double("operand")
    allow(op1).to receive(:depth) {2}
    op2 =  double("operand")
    allow(op2).to receive(:depth) {3}
    expr = BinaryExpression.new(nil,  op1, op2)
    expect(expr.depth).to eq(4)
  end
  describe "#opCount" do
    it "is 1 plus opCount of the two operands" do
      op1 =  double("operand")
      allow(op1).to receive(:opCount) {2}
      op2 =  double("operand")
      allow(op2).to receive(:opCount) {1}
      operator = double("operator")
      allow(operator).to receive(:opCount) {5}
      expr = BinaryExpression.new(operator,  op1, op2)
      expect(expr.opCount).to eq(5 + 2 + 1)
    end
  end
      
    
end
