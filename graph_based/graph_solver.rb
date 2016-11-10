$LOAD_PATH << File.join(Dir.pwd ,"graph_based")

require "util"
require "graph"
require "root"
require "binary_expr"

require "operators"

class GraphPotySolver < PotySolver
  attr_reader :graph, :roots
  def solve(digits, range)
    puts "Solving for #{range}"
    super(digits, range)

    @graph = Graph.new()

    @roots = digits.map { |d| Root.new(d.to_i)}
    @roots.each {|root| graph.add(root)}

    binary_candidates {|operator, left, right|
      consider(graph.add(BinaryExpr.new(operator, left, right)))
    }

    results
  end

  def consider(n)
    if n.terminal? && ! n.dead?
      v = n.value
      puts "VALUE #{v}"
      add_result(v, n.to_expression) if interesting?(v)
    end
  end

  # generate triples of operator, operand1 operand2 as long as there are viable nodes in the graph
  def binary_candidates ()
    yield Plus, @roots[0], roots[1]
    yield Plus, @roots[1], roots[2]
    yield Plus, @roots[2], roots[3]
    yield Plus, graph.nodes[4], graph.nodes[5]
    yield Plus, graph.nodes[5], graph.nodes[6]
  end

end
