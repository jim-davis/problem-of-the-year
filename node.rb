# An node in an expression tree.
# The node may be a Digit or and Expression

class Node
  attr_reader :leaves, :value, :depth, :arboretum
  attr_writer :arboretum
  def initialize(leaves, value, depth)
    @leaves=leaves
    @value=value
    @depth=depth
  end
  def leftmost_leaf
    @leaves.first
  end
  def rightmost_leaf
    @leaves.last
  end
  def alive?
    ! value.nil?
  end
  def dead?
     !alive?
  end
  def terminal?
    leaves.count == arboretum.leaves.count
  end
end
