class MonadicExpr < Expr
  def initialize (operator, operand)
    super(operator, [operand])
  end
end
