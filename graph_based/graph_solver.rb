$LOAD_PATH << File.join(Dir.pwd ,"graph_based")

require "util"
require "graph"
require "root"
require "binary_expr"

require "operators"

class GraphPotySolver < PotySolver
  attr_reader :graph
  def solve(digits, range)
    puts "Solving for #{range}"
    super(digits, range)

    @graph = Graph.new(digits.map { |d| Root.new(d.to_i)})

    gt = GraphTraverser.new(graph)
    gt.each do |operator, left, right| 
      consider(graph.add(BinaryExpr.new(operator, left, right)))
      puts "Graph has #{graph.nodes.count} nodes"
    end

    results
  end

  def consider(n)
    puts "Consider #{n.value}"
    if n.terminal? && n.alive?
      stats.countEvaluation
      v = n.value
      puts "VALUE #{v}"
      stats.countExpression
      add_result(v, n.to_expression) if interesting?(v)
    end
  end


end

# find node L such that 
# L is not terminal
# L is alive
# there exists another node R
# that is not terminal and is alive
#  whose left ancestor is adjacent to the right ancestor of L
# and there exists a binary operator O such there is no existing Node (O L R)

class GraphTraverser
  attr_reader :graph
  include Enumerable
  def initialize(graph)
    @graph = graph
  end

  def each (&block)
    graph.nodes.select {|l| !l.terminal? && l.alive?}.each {|l| 
      graph.nodes.select { |r| !r.terminal? && r.alive? && graph.adjacent_ancestors?(l,r)}.each { |r|
        op = Plus
        block.call([op, l, r])
      }
    }
  end

end
