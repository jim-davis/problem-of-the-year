# A collection of trees.
# All trees have a common set of leaf nodes (these are the digits given for the problem)
class Arboretum
  attr_reader :nodes, :leaves
  include Enumerable
  def initialize(leaves)
    @nodes = []
    @leaves = leaves
    leaves.each { |n| add(n)}
  end

  def add(node)
    node.arboretum=self
    @nodes << node
    node
  end

  def each (&block)
    nodes.each { |n| block.call(n)}
  end

  # Do two nodes have adjacent leaves?
  def adjacent_leaves?(n,m)
    leaves.find_index(n.rightmost_leaf) == leaves.find_index(m.leftmost_leaf) - 1 
  end

  def find_expression(op, l, r)
    find { |existing| 
      existing.respond_to?(:operator) &&
      existing.respond_to?(:left) &&
      existing.respond_to?(:right) &&
      existing.operator.eql?(op) &&
      existing.left.eql?(l) &&
      existing.right.eql?(r)}
  end

  def find_monadic_expression(op, operand)
    find { |existing|
      existing.respond_to?(:operator) &&
      existing.respond_to?(:operand) &&
      existing.operator.eql?(op) &&
      existing.operand.eql?(operand)}
  end

  def left_neighbour(leaf)
    i = leaves.find_index(leaf)
    i == 0 ? nil : leaves[i-1]
  end

  def right_neighbour(leaf)
    i = leaves.find_index(leaf)
    i == leaves.length - 1 ? nil : leaves[i+1]
  end
      
end
