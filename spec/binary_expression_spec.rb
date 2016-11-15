require "binary_expression"

describe BinaryExpression do
  describe "#initialze" do
    before(:each) do
      la = [1, 2]
      @left = double("Node")
      allow(@left).to receive(:leaves) {la}
      allow(@left).to receive(:value) {4}
      allow(@left).to receive(:depth) {5}
      ra = [3, 4]
      @right = double("Node")
      allow(@right).to receive(:leaves) {ra}
      allow(@right).to receive(:value) {9}
      allow(@right).to receive(:depth) {2}
      @op = double("Operator")
      allow(@op).to receive(:evaluate) 
    end

    it "makes a Node where the leaves are the combination of the left and right leaves" do
      r = BinaryExpression.new(@op, @left, @right)
      expect(r.leaves).to eq([1,2,3,4])
    end

    it "makes a Node whose value is obtained by evaluating the operator on the values" do
      expect(@op).to receive(:evaluate).with([4,9])
      r = BinaryExpression.new(@op, @left, @right)
    end

    it "makes a Node whose depth is the max of depths of left and right plus 1" do
      r = BinaryExpression.new(@op, @left, @right)
      expect(r.depth).to eq(6)
    end

    describe "when the expression can't be evaluated" do
      it "makes a Node that is dead" do
        allow(@op).to receive(:evaluate).and_raise(RangeError)
        r = BinaryExpression.new(@op, @left, @right)
        expect(r.dead?).to be true
      end
    end
    
    it "has depth 1 greater than max depth of its two operands" do
      r = BinaryExpression.new(@op, @left, @right)
      expect(r.depth).to eq(6)
    end
  end
      
end
