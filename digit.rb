require "node"

class Digit < Node
  def evaluate
    value
  end
  def initialize(v)
    super([self], v.to_i, 0)
  end
  def to_s
    value.to_s
  end
  def stringify(parent_precedence)
    # precedence is not significant to a digit
    to_s
  end
  def eql?(o)
    o.is_a?(Digit) && o.value == self.value
  end
  def hash
    value.hash
  end
  def inspect
    value
  end
  
end

