require "Rspec"
require "operators"

describe MonadicOperator do
  describe "#expression_string" do
    describe "when postfix" do
      it "appends the symbol to the operand" do
        op = MonadicOperator.new("@", nil, :POST)
        operand = double("operand")
        allow(operand).to receive(:to_s) {"259"}
        expect(op.expression_string(operand)).to eql("259@")
      end
    end
    describe "otherwise" do
      it "encloses operand in parenthesis" do
        op = MonadicOperator.new("@", nil, :PRE)
        operand = double("operand")
        allow(operand).to receive(:to_s) {"259"}
        expect(op.expression_string(operand)).to eql("@(259)")
      end
    end
  end
end

describe BinaryOperator do
end


