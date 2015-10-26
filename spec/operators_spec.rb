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
  describe "#expression_string" do
    describe "when prefix" do
      it "encloses operands in brackets" do
        op = BinaryOperator.new("@", nil, :PRE)
        op1 = double("operand")
        allow(op1).to receive(:to_s) {"259"}
        op2 = double("operand")
        allow(op2).to receive(:to_s) {"11"}
        expect(op.expression_string(op1, op2)).to eql("@(259,11)")
      end
    end
    describe "if not prefix (infix)" do
      it "assumes infix" do
        op = BinaryOperator.new("@", nil, :IN)
        op1 = double("operand")
        allow(op1).to receive(:to_s) {"259"}
        op2 = double("operand")
        allow(op2).to receive(:to_s) {"11"}
        expect(op.expression_string(op1, op2)).to eql("(259 @ 11)")
      end
    end
  end
end

describe "Plus" do
  describe "#evaluate" do
    it "adds the two operands" do
      expect(Plus.evaluate([10,11])).to eq(21)
    end
  end
end

describe "Minus" do
  describe "#evaluate" do
    it "subtracts second from first" do
      expect(Minus.evaluate([10,11])).to eq(-1)
    end
  end
end

describe "Times" do
  describe "#evaluate" do
    it "multiplies the two operands" do
      expect(Times.evaluate([10,11])).to eq(110)
    end
  end
end

describe "Divide" do
  describe "#evaluate" do
    it "divides first by second" do
      expect(Divide.evaluate([8,4])).to eq(2)
    end
  end
end

describe "Expt" do
  describe "#evaluate" do
    it "raises first to second" do
      expect(Expt.evaluate([2,10])).to eq(1024)
    end
  end
end

describe "Log" do
  describe "#evaluate" do
    it "returns number you raise second to get first" do
      expect(Log.evaluate([ 1024, 2])).to be_within(0.001).of(10)
    end
  end
end

describe "Mod" do
  describe "#evaluate" do
    it "returns first modulo second" do
      expect(Mod.evaluate([11, 3])).to eq(2)
    end
  end
end



describe "Abs" do
  describe "#evaluate" do
    it "0 is 0" do
      expect(Abs.evaluate([0])).to eq(0)
    end
    it "-10 is 10" do
      expect(Abs.evaluate([-10])).to eq(10)
    end
  end
end

