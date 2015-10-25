require "operators"

class Expression
  def evaluate
    raise RuntimeError "Called evaluate on Abstract class Expression"
  end
end

# An Expression is either Digit or an operator expression
# We are allowed to combine digits by string concatentation (e.g. "1" &  "8" == "18")

class Digit < Expression
  attr_accessor :value
  def evaluate
    value.to_i
  end
  def initialize(v)
    self.value=v.to_i
  end
  def to_s
    value
  end

  def eql?(o)
    o.is_a?(Digit) && o.value == self.value
  end

  def hash
    value.hash
  end
  
end

class OpExpression < Expression
  attr_reader :operator, :operands
  def evaluate
    operator.evaluate(operands.map(&:evaluate))
  end

  def eql?(o)
    o.is_a?(self.class) && 
      operator.eql?(o.operator) && 
      operands.eql?(o.operands)
  end
  def hash
    self.class.hash ^ self.operator.hash ^ operands.hash
  end
  
end

class MonadicExpression < OpExpression
  def initialize(operator, operand)
    @operator = operator
    @operands = [operand]
    def to_s
      @operator.expression_string(@operands[0])
    end
  end
end

class BinaryExpression < OpExpression
  def initialize(operator, operand1, operand2)
    @operator = operator
    @operands = [operand1, operand2]
  end
  def to_s
    @operator.expression_string(@operands[0], @operands[1])
  end
  def lhs
    operands[0]
  end
  def rhs
    operands[1]
  end
  def eql?(o)
    o.is_a?(self.class) && 
      operator.eql?(o.operator) && 
      (operands.eql?(o.operands) || 
       operator.commutative? && operands.reverse.eql?(o.operands))
  end
  def hash
    if operator.commutative?
      self.class.hash ^ self.operator.hash ^ self.lhs.hash ^ self.rhs.hash
    else
      self.class.hash ^ self.operator.hash ^ self.operands.hash
    end
  end

end

if __FILE__ == $0
  expr = MonadicExpression.new(Fact, Digit.new(3))
  puts "#{expr.to_s} == #{expr.evaluate}"
end
