$LOAD_PATH << File.join(Dir.pwd ,"graph_based")

require "util"
require "arboretum"
require "digit"
require "binary_expression"

require "operators"

class GraphPotySolver < PotySolver
  attr_reader :arboretum
  def solve(digits, range)
    puts "Solving for #{range}"
    super(digits, range)

    @arboretum = Arboretum.new(digits.map { |d| Digit.new(d.to_i)})

    gt = GraphTraverser.new(arboretum)
    gt.each do |operator, left, right| 
      consider(arboretum.add(BinaryExpression.new(operator, left, right)))
    end

    gt.each do |operator, left, right| 
      consider(arboretum.add(BinaryExpression.new(operator, left, right)))
    end

    arboretum.nodes.each {|n| puts n}

    results
  end

  def consider(n)
    raise "Too deep #{n}" if n.depth > 4
    if n.terminal? && n.alive?
      stats.countEvaluation
      v = n.value
      puts "VALUE #{v} #{n}"
      stats.countExpression
      add_result(v, n) if interesting?(v)
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
  attr_reader :arboretum
  include Enumerable
  def initialize(arboretum)
    @arboretum = arboretum
  end

  def each (&block)
    arboretum.nodes.select {|l| !l.terminal? && l.alive?}.each do |l| 
      arboretum.nodes.select { |r| !r.terminal? && r.alive? && arboretum.adjacent_leaves?(l,r)}.each do |r|
        [Concat, Plus, Times, Minus, Divide ].each do |op| 
          block.call([op, l, r]) if !arboretum.find_expression(op, l, r)
        end
      end
    end
  end
end
