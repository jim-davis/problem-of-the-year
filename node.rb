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
    ! dead?
  end
  def dead?
     value.nil? || (value.is_a?(Float) && (value.infinite? || value.nan?))
  end
  def terminal?
    leaves.count == arboretum.leaves.count
  end
  def consecutive_monadic_operator_count
    0
  end
end
