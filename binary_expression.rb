require "expression"

class BinaryExpression < Expression
  attr_reader :left, :right
  def initialize(operator, left, right)
    @left=left
    @right=right
    super(operator, [left, right])
  end
  def stringify(parent_precedence)
    @operator.expression_string(parent_precedence, @operands[0], @operands[1])
  end
end
