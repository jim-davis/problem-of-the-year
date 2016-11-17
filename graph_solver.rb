$LOAD_PATH << File.join(Dir.pwd ,"graph_based")

require "util"
require "arboretum"
require "digit"
require "binary_expression"
require "monadic_expression"
require "operators"

require "operators"

class GraphPotySolver < PotySolver
  attr_reader :arboretum
  def solve(digits, range)
    super(digits, range)

    @arboretum = Arboretum.new(digits.map { |d| Digit.new(d.to_i)})
    gt = GraphTraverser.new(arboretum)
    gt.each do |operator, left, right| 
      consider(arboretum.add(BinaryExpression.new(operator, left, right)))
    end

    results
  end

  def consider(n)
    # a node is a possible solution if it uses all four digits and has a value
    # and if the value is interesting then it really IS a solution.
    if n.terminal? && n.alive?
      stats.countEvaluation
      v = n.value
      stats.countExpression
      add_result(v, n) if interesting?(v)
    end
  end


end

# Generate possible nodes (O, L, R)
# L is not terminal
# L is alive
# there exists another node R
# that is not terminal and is alive
# whose left ancestor is adjacent to the right ancestor of L
# and there exists a binary operator O such there is no existing Node (O L R)
class GraphTraverser
  attr_reader :arboretum
  include Enumerable
  def initialize(arboretum)
    @arboretum = arboretum
  end

  # invoke block repeatedly with candidate notes (O,L,R)
  def each (&block)
    progress = true
    while progress do
      progress = false
      arboretum.nodes.select {|l| !l.terminal? && l.alive?}.each do |l| 
        arboretum.nodes.select { |r| !r.terminal? && r.alive? && arboretum.adjacent_leaves?(l,r)}.each do |r|
          [Concat, Plus, Times, Minus, Divide, Expt ].each do |op| 
            if op.applies_to?(l, r) && !arboretum.find_expression(op, l, r) 
              progress = true
              block.call([op, l, r]) 
            end
          end
        end
      end
      if ! progress
        puts "no progress, adding monadic ops"
        arboretum.nodes.select{ |n| !n.terminal? && n.alive?}.each do |operand|
          [PrefixMinus, Decimalize, RepeatingDecimal, Fact, Sqrt].each do |op|
            if op.applies_to?(operand) && ! arboretum.find_monadic_expression(op, operand)
              # add a depth limit
              begin
                expr = MonadicExpression.new(op, operand)
                puts "Adding #{expr}"
                progress = true
                arboretum.add(expr)
              rescue Noop => e
                puts e
              end
            end                 # end op
          end                   # end node each
        end                     # catch
      end                       # !progress
    end
  end
end
