$LOAD_PATH << File.join(Dir.pwd ,"graph_based")

require "graph"

class GraphPotySolver < PotySolver
  def solve(digits, range)
    super(digits, range)

  end
end
