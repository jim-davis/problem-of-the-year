require "expr"

class BinaryExpr < Expr
  attr_reader :left, :right
  def initialize(operator, left, right)
    super(operator, [left, right])
    @left = left
    @right = right
  end

  def to_expression
    BinaryExpression.new(operator, left.to_expression, right.to_expression)
  end

end
