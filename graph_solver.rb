$LOAD_PATH << File.join(Dir.pwd ,"graph_based")

require "util"
require "arboretum"
require "digit"
require "binary_expression"
require "monadic_expression"
require "operators"

require "operators"

class GraphPotySolver < PotySolver
  def solve(digits, range)
    super(digits, range)
    @arboretum = Arboretum.new(digits.map { |d| Digit.new(d.to_i)})
    @max_expressions = 30 * 1000 * 1000
    unexplored = []

    @arboretum.leaves.each { |leaf| unexplored.push(leaf)}
    @explored = 0
    @seen = 0
    while ((node = unexplored.shift) && !complete? && @explored < @max_expressions)
      @explored+=1
      puts "#{@explored} nodes explored. #{unexplored.length} remaining #{@arboretum.nodes.count} nodes. #{nsolved} solved" if (@explored % 10 == 0) && verbose
      added = 0
      next_nodes(node) do |expr| 
        if expr.alive?
          added+=1
          @arboretum.add(expr)
          unexplored.push(expr)
          # a node is a possible solution if it uses all four digits and has a value
          # and if the value is interesting then it really IS a solution.
          if expr.terminal?
            stats.countEvaluation
            v = expr.value
            stats.countExpression
            add_result(v, expr) if interesting?(v)
          end
        end
      end

    end
    results
  end

  def next_nodes(node, &block) 
    [PrefixMinus, Decimalize, RepeatingDecimal, Fact, Sqrt].
      select {|op| op.applies_to?(node)}.
      each do |op|
      begin
        block.call(MonadicExpression.new(op, node))
      rescue Noop => e
      end
    end

    node.left_adjacents.each do |l|
      [Concat, Plus, Times, Minus, Divide, Expt ].
        select { | op| op.applies_to?(l, node)}.
# We don't search for duplicates because it slows the program extremely
# we'd need to give each node a pointer to every expression that used it 
#        reject { |op| @arboretum.find_expression(op, l, node)}.
        each { |op| block.call(BinaryExpression.new(op, l, node))}
    end

    node.right_adjacents.each do |r|
      [Concat, Plus, Times, Minus, Divide, Expt ].
        select { | op| op.applies_to?(node, r)}.
#        reject { |op| @arboretum.find_expression(op, node, r)}.
        each { |op| block.call(BinaryExpression.new(op, node, r))}
    end

  end
        
end
