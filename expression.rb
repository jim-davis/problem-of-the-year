require "node"

class Expression < Node
  attr_reader :operator, :operands
  def initialize(operator, operands)
    begin
      v = operator.evaluate(operands.map {|op| op.value})
    rescue RangeError => e
      v = nil
    end
    super(operands.flat_map(&:leaves), 
          v,
          operands.map(&:depth).max + 1)
    @operator = operator
    @operands = operands
  end
  def evaluate
    value
  end
  def eql?(o)
    o.is_a?(self.class) && 
      operator.eql?(o.operator) && 
      operands.eql?(o.operands) 
  end
  def hash
    self.class.hash ^ self.operator.hash ^ self.operands.hash
  end
  def to_s
    stringify(-1)
  end
end
