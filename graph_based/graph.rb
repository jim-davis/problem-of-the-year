# Directed Acyclic Graph.
# A set of Nodes, some of which are Roots.  
# the set of root nodes is set at initialization time
# Cycles are not actually prohibited, but I don't need them
class Graph
  attr_reader :nodes, :roots
  include Enumerable
  def initialize(roots)
    @nodes = []
    @roots = roots
    roots.each { |n| add(n)}
  end
  def add(node)
    node.graph=self
    @nodes << node
    node
  end
  def each (&block)
    nodes.each { |n| block.call(n)}
  end

  def adjacent_ancestors?(n,m)
    roots.find_index(n.rightmost_ancestor) == roots.find_index(m.leftmost_ancestor) - 1 ||
    roots.find_index(n.leftmost_ancestor) == roots.find_index(m.rightmost_ancestor) + 1 
  end
 
end
