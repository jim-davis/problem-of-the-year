class Node
  attr_reader :ancestors, :value, :depth
  def initialize(ancestors, value, depth)
    @ancestors=ancestors
    @value=value
    @depth=depth
  end
  def leftmost_ancestor
    @ancestors.first
  end
  def rightmost_ancestor
    @ancestors.last
  end
end

class Root < Node
  def initialize(digit)
    super([self], digit, 0)
  end
end

class Expr < Node
  attr_reader :operator
  def initialize(operator, operands)
    super(operands.flat_map(&:ancestors), 
          operator.evaluate(operands.map(&:value)),
          operands.map(&:depth).max + 1)
    @operator = operator
    @operands = operands
  end
end

class BinaryExpr < Expr
  def initialize(operator, left, right)
    super(operator, [left, right])
    @left = left
    @right = right
  end
end

class MonadicExpr < Expr
  def initialize (operator, operand)
    super(operator, [operand])
  end
end
