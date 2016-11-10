require "node"

require "expressions"

class Expr < Node
  attr_reader :operator
  def initialize(operator, operands)
    begin
      v = operator.evaluate(operands.map {|op| op.value})
    rescue RangeError => e
      v = nil
    end
    super(operands.flat_map(&:ancestors), 
          v,
          operands.map(&:depth).max + 1)
    @operator = operator
    @operands = operands
  end

end
