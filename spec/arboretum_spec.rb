require "arboretum"
require "node"

describe Arboretum do
  before(:each) do
    @leaves = %w(1 2 3).map do |v| 
      r = double("Node")
      allow(r).to receive(:arboretum=)
      r
    end

    @arboretum = Arboretum.new (@leaves)
    expect(@arboretum.nodes.count).to eq(3)

    @child_of_0 = double("Node")
    allow(@child_of_0).to receive(:leftmost_leaf) {@leaves[0]}
    allow(@child_of_0).to receive(:rightmost_leaf) {@leaves[0]}

    @child_of_1 = double("Node")
    allow(@child_of_1).to receive(:leftmost_leaf) {@leaves[1]}
    allow(@child_of_1).to receive(:rightmost_leaf) {@leaves[1]}
  end
    
  describe "#adjacent_leaves?" do
    it "is true if the right leaf of M is one before the left leaf of N" do
      expect(@arboretum.adjacent_leaves?(@child_of_0,@child_of_1)).to be true
    end

    it "is false if the left leaf of M is one before the right leaf of N" do
      expect(@arboretum.adjacent_leaves?(@child_of_1,@child_of_0)).to be false
    end

    it "is false for n,n" do
      expect(@arboretum.adjacent_leaves?(@child_of_1,@child_of_1)).to be false
    end
  end

  describe "#add" do
    before(:each) do
      @node = double("Node")
      allow(@node).to receive(:arboretum=).with(@arboretum)
    end

    it "gives the node a pointer to the arboretum" do
      @arboretum.add(@node)
    end

    it "increases the count of nodes" do
      c = @arboretum.nodes.count
      @arboretum.add(@node)
      expect(@arboretum.nodes.count).to eq(c+1)
    end
  end

  describe "#find_expression" do
    before(:each) do
      @op = double("Operator")
      allow(@op).to receive(:eql?).with(@op) {true}

      @l = double("Node")
      @r = double("Node")

      allow(@l).to receive(:eql?).with(@l) {true}
      allow(@l).to receive(:eql?).with(@r) {false}
      
      allow(@r).to receive(:eql?).with(@l) {false}
      allow(@r).to receive(:eql?).with(@r) {true}

      @expr = double("Expr")
      allow(@expr).to receive(:arboretum=).with(@arboretum)
      allow(@expr).to receive(:operator) {@op}
      allow(@expr).to receive(:left) {@l}
      allow(@expr).to receive(:right) {@r}
    end

    describe "if the expression has been added" do
      it "returns the expression" do
        @arboretum.add(@expr)
        expect(@arboretum.find_expression(@op, @l, @r)).to eq(@expr)
      end
    end

    describe "if the expression has not been added" do
      it "returns nil" do
        expect(@arboretum.find_expression(@op, @l, @r)).to be(nil)
      end
    end
               
  end
end
