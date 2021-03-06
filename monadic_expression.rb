require "expression"

class MonadicExpression < Expression
  attr_reader :operand
  def initialize(operator, operand)
    @operand = operand
    super(operator, [operand])
  end
  def stringify(parent_precedence)
    @operator.expression_string(parent_precedence, @operands[0])
  end
  def consecutive_monadic_operator_count
    1 + operand.consecutive_monadic_operator_count
  end

end
