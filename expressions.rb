class Expression
  def evaluate
  end
end

class Digit < Expression
  attr_accessor :value
  def evaluate
    value.to_i
  end
  def initialize(v)
    if !v.is_a?(String)
      binding.pry
    end
    self.value=v
  end
  def to_s
    value
  end
end

class OpExpression < Expression
  attr_accessor :operator, :operands
  def evaluate
    operator.evaluate(operands.map(&:evaluate))
  end
end

class MonadicExpression < OpExpression
  def initialize(operator, operand)
    self.operator = operator
    self.operands = [operand]
  end
end

class BinaryExpression < OpExpression
  def initialize(operator, operand1, operand2)
    self.operator = operator
    self.operands = [operand1, operand2]
  end
  def to_s
    "(#{operands[0].to_s} #{operator.symbol} #{operands[1].to_s})"
  end
end

class Operator
  attr_accessor :symbol, :f
  def initialize(symbol, f)
    self.symbol = symbol
    self.f = f
  end
end

class BinaryOperator < Operator
  def evaluate(operands)
    f.call(operands[0], operands[1])
  end
  def is_commutative?
    false
  end
end

class CommutativeOperator < BinaryOperator
  def is_commutative?
    true
  end
end



if __FILE__ == $0
Digit.new("23").evaluate
  #puts Plus.evaluate([1, 2])
  expr = BinaryExpression.new(Plus, Digit.new("1"), 
                              BinaryExpression.new(Times, Digit.new("2"), Digit.new("3")))
  puts "#{expr.to_s} == #{expr.evaluate}"
end
