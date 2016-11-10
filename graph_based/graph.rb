class Graph
  attr_reader :nodes
  def initialize()
    @nodes = []
  end
  def add(node)
    @nodes << node
    node
  end
end
