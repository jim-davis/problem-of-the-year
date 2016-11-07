$LOAD_PATH << File.join(Dir.pwd ,"tree_based")

require "generate"
require "util"

class TreePotySolver < PotySolver
  def solve(digits, range)
    super(digits, range)

    @expression_counter = 0
    catch (:success) do
      generate_expressions(digits, allow_permutations, stats) { |expr| examine(expr)}
    end
    results
  end

  def examine (expr) 
    stats.countExpression
    begin
      v = expr.evaluate
      stats.countEvaluation

      add_result(v, expr) if interesting?(v) 
      throw :success if complete?
    rescue RangeError => e
      # Several operators raise RangeError to stop processing, e.g. for factorial argument too large
      # ignore
    rescue Noop => e
      # The expression includes an operator that is a Noop, which means there is guaranteed to be
      # a simpler way to say the same thing.  So ignore it
    end
  end
end
