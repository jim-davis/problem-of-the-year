require "operators"
require "extra_operators"
require "digit"
require "binary_expression"

describe MonadicOperator do
  describe "#expression_string" do
    describe "when postfix" do
      it "appends the symbol to the operand" do
        postfix_operator = MonadicOperator.new("@", 0,  nil, :POST)
        operand = double("operand")
        allow(operand).to receive(:stringify) {"259"}
        expect(postfix_operator.expression_string(-1, operand)).to eql("259@")
      end
    end
    describe "otherwise" do
      it "encloses operand in parenthesis" do
        op = MonadicOperator.new("@", 0, nil, :PRE)
        operand = double("operand")
        allow(operand).to receive(:stringify) {"259"}
        expect(op.expression_string(-1, operand)).to eql("@(259)")
      end
    end
  end
end

describe BinaryOperator do

  describe "#expression_string" do

    describe "operator is prefix" do
      describe "when precedence is lower than context" do
        it "encloses operands in brackets" do
          op = BinaryOperator.new("@", 0, nil, :PRE)
          op1 = double("operand")
          allow(op1).to receive(:stringify) {"259"}
          op2 = double("operand")
          allow(op2).to receive(:stringify) {"11"}
          expect(op.expression_string(1, op1, op2)).to eql("@(259,11)")
        end
      end
      describe "when precedence is higher than context" do
        it "does not use brackets" do
          op = BinaryOperator.new("@", 0, nil, :PRE)
          op1 = double("operand")
          allow(op1).to receive(:stringify) {"259"}
          op2 = double("operand")
          allow(op2).to receive(:stringify) {"11"}
          expect(op.expression_string(-1, op1, op2)).to eql("@(259,11)")
        end
      end
    end

    describe "operator is infix" do
      describe "when precedence is lower than context" do
        it "encloses operands in brackets" do
          op = BinaryOperator.new("@", 0, nil, :IN)
          op1 = double("operand")
          allow(op1).to receive(:stringify) {"259"}
          op2 = double("operand")
          allow(op2).to receive(:stringify) {"11"}
          expect(op.expression_string(1, op1, op2)).to eql("(259 @ 11)")
        end
      end
      describe "when precedence is higher than context" do
        it "omits brackets" do
          op = BinaryOperator.new("@", 0, nil, :IN)
          op1 = double("operand")
          allow(op1).to receive(:stringify) {"259"}
          op2 = double("operand")
          allow(op2).to receive(:stringify) {"11"}
          expect(op.expression_string(-1, op1, op2)).to eql("259 @ 11")
        end
      end
      describe "when precedence is same as context" do
        describe "when operator is associative" do
          it "omits brackets" do
            op = BinaryOperator.new("@", 0, nil, :IN, true)
            op1 = double("operand")
            allow(op1).to receive(:stringify) {"259"}
            op2 = double("operand")
            allow(op2).to receive(:stringify) {"11"}
            expect(op.expression_string(0, op1, op2)).to eql("259 @ 11")
          end
        end
        describe "when operator is not associative" do
          it "encloses expression in brackets" do
            op = BinaryOperator.new("@", 0, nil, :IN, false)
            op1 = double("operand")
            allow(op1).to receive(:stringify) {"259"}
            op2 = double("operand")
            allow(op2).to receive(:stringify) {"11"}
            expect(op.expression_string(0, op1, op2)).to eql("(259 @ 11)")
          end
        end
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
      expect(Expt.evaluate([2,5])).to eq(32)
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

describe "Fact" do
  describe "#evaluate" do
    it "computes factorial" do
      expect(Fact.evaluate([5])).to eq(5 * 4 * 3 * 2)
    end
  end
end

describe "Concat" do
  describe "#evaluate" do
    it "concatenates its arguments" do
      expect(Concat.evaluate([1, 5])).to eq(15)
    end
  end
  describe "#expression_string" do
    it "concatenates" do
      expect(Concat.expression_string(0, 1, 2)).to eq("12")
    end
  end
  describe "applies_to?" do
    it "can be applied to Digits" do
      expect(Concat.applies_to?(Digit.new("1"), Digit.new("2"))).to be true
    end
    it "can be applied to Concat" do
      d = Digit.new("1")
      concat = double("BinaryExpression")
      allow(concat).to receive(:is_a?).with(Digit) {false}
      allow(concat).to receive(:is_a?).with(BinaryExpression) {true}
      allow(concat).to receive(:operator) {Concat}
      expect(Concat.applies_to?(concat, d)).to be true
    end
    it "can not be applied to other expr Concat" do
      d = Digit.new("1")
      plus = double("BinaryExpression")
      allow(plus).to receive(:is_a?).with(Digit) {false}
      allow(plus).to receive(:is_a?).with(BinaryExpression) {true}
      allow(plus).to receive(:operator) {Plus}
      expect(Concat.applies_to?(plus, d)).to be false
    end
  end
end

describe "Decimalize" do
  describe "#evaluate" do
    it "computes divides by 10" do
      expect(Decimalize.evaluate([5])).to eq(0.5)
    end
  end
  describe "#expression_string" do
    it "prepends a dot" do
      expect(Decimalize.expression_string(0, Digit.new(1))).to eq(".1")
    end
  end
end

describe "RepeatingDecimal" do
  describe "#evaluate" do
    it ".9_ is 1" do
      expect(RepeatingDecimal.evaluate([9])).to eq(1)
    end
  end
  describe "#applies_to?" do
    it "applies_to 9" do
      expect(RepeatingDecimal.applies_to?(Digit.new(9))).to be(true)
    end
    it "does not apply_to any other digit" do
      expect(RepeatingDecimal.applies_to?(Digit.new(1))).to be(false)
    end

  end
  describe "#expression_string" do
    it "prepends a dot and postpends a bar" do
      expect(RepeatingDecimal.expression_string(0, Digit.new(1))).to eq(".1_")
    end
  end
end
