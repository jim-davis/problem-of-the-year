class Node
  attr_reader :ancestors, :value, :depth, :graph
  attr_writer :graph
  def initialize(ancestors, value, depth)
    @ancestors=ancestors
    @value=value
    @depth=depth
  end
  def leftmost_ancestor
    @ancestors.first
  end
  def rightmost_ancestor
    @ancestors.last
  end
  def alive?
    ! value.nil?
  end
  def dead?
     !alive?
  end
  def terminal?
    ancestors.count == graph.roots.count
  end
end
