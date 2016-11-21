# An node in an expression tree.
# The node may be a Digit or and Expression

# To enable quickly constructing trees: We identify a set of leaf nodes
# each node knows the set of all its leaves,
class Node
  attr_reader :leaves, :value, :depth, :arboretum, :right_ancestors, :left_ancestors
  attr_writer :arboretum
  def initialize(leaves, value, depth)
    @leaves=leaves
    @value=value
    @depth=depth
    @left_ancestors=[]
    @right_ancestors=[]
    leftmost_leaf.add_right_ancestor(self)
    rightmost_leaf.add_left_ancestor(self)
  end
  def leftmost_leaf
    leaves.first
  end
  def rightmost_leaf
    leaves.last
  end
  def alive?
    ! dead?
  end
  def dead?
     value.nil? || (value.is_a?(Float) && (value.infinite? || value.nan?))
  end
  def terminal?
    raise "Node has no leaves #{self.inspect}" if leaves.nil?
    raise "Node has no arboretum #{self.inspect}" if arboretum.nil?
    raise "Arb has no leaves #{arboretum.inspect}" if arboretum.leaves.nil?
    leaves.count == arboretum.leaves.count
  end

  def consecutive_monadic_operator_count
    0
  end

  def left_adjacents
    leftmost_leaf.left_neighbour_leaf ?  leftmost_leaf.left_neighbour_leaf.left_ancestors : []
  end

  def left_neighbour_leaf
    arboretum.left_neighbour(self)
  end

  def add_left_ancestor(n)
    @left_ancestors.push(n)
  end

  def right_adjacents
    rightmost_leaf.right_neighbour_leaf ?  rightmost_leaf.right_neighbour_leaf.right_ancestors : []
  end

  def right_neighbour_leaf
    arboretum.right_neighbour(self)
  end

  def add_right_ancestor(n)
    @right_ancestors.push(n)
  end


end
