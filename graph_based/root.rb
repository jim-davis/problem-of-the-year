require "node"
require "expressions"

class Root < Node
  def initialize(digit)
    super([self], digit, 0)
  end

  def to_s
    value.to_s
  end
  
  def to_expression
    Digit.new(value)
  end
end
