require "expression"

class MonadicExpression < Expression
  def initialize(operator, operand)
    super(operator, [operand])
  end
  def stringify(parent_precedence)
    @operator.expression_string(parent_precedence, @operands[0])
  end
end
