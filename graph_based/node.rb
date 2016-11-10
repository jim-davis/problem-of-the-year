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
  def dead?
    value.nil?
  end
  def terminal?
    ancestors.count == 4
  end
end
