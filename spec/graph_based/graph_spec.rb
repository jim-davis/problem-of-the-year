b = Dir.pwd
$LOAD_PATH << b
$LOAD_PATH << File.join(b,"graph_based")

require "Rspec"
require "graph"
require "Root"

describe Graph do
  before(:each) do
    @roots = %w(a b c).map do |v| 
      r = double("Root")
      allow(r).to receive(:graph=)
      r
    end


    @graph = Graph.new (@roots)

    @child_of_0 = double("Node")
    allow(@child_of_0).to receive(:leftmost_ancestor) {@roots[0]}
    allow(@child_of_0).to receive(:rightmost_ancestor) {@roots[0]}

    @child_of_1 = double("Node")
    allow(@child_of_1).to receive(:leftmost_ancestor) {@roots[1]}
    allow(@child_of_1).to receive(:rightmost_ancestor) {@roots[1]}
  end
    
  describe "#adjacent_ancestors?" do
    it "is true if the right ancestor of M is one before the left ancestor of N" do
      expect(@graph.adjacent_ancestors?(@child_of_0,@child_of_1)).to be true
    end
    it "is true if the left ancestor of M is one before the right ancestor of N" do
      expect(@graph.adjacent_ancestors?(@child_of_1,@child_of_0)).to be true
    end

    it "is false for n,n" do
      expect(@graph.adjacent_ancestors?(@child_of_1,@child_of_1)).to be false
    end
  end
end

    
      
             
