require "Rspec"

b = Dir.pwd
$LOAD_PATH << b
$LOAD_PATH << File.join(b,"graph_based")

require "binary_expr"

describe BinaryExpr do
  describe "#initialze" do
    before(:each) do
      la = [1, 2]
      @left = double("Node")
      allow(@left).to receive(:ancestors) {la}
      allow(@left).to receive(:value) {4}
      allow(@left).to receive(:depth) {5}
      ra = [3, 4]
      @right = double("Node")
      allow(@right).to receive(:ancestors) {ra}
      allow(@right).to receive(:value) {9}
      allow(@right).to receive(:depth) {2}
      @op = double("Operator")
      allow(@op).to receive(:evaluate) 
    end

    it "makes a Node where the ancestors are the combination of the left and right ancestors" do
      r = BinaryExpr.new(@op, @left, @right)
      expect(r.ancestors).to eq([1,2,3,4])
    end

    it "makes a Node whose value is obtained by evaluating the operator on the values" do
      expect(@op).to receive(:evaluate).with([4,9])
      r = BinaryExpr.new(@op, @left, @right)
    end

    it "makes a Node whose depth is the max of depths of left and right plus 1" do
      r = BinaryExpr.new(@op, @left, @right)
      expect(r.depth).to eq(6)
    end

    describe "when the expression can't be evaluated" do
      it "makes a Node that is dead" do
        allow(@op).to receive(:evaluate).and_raise(RangeError)
        r = BinaryExpr.new(@op, @left, @right)
        expect(r.dead?).to be true
      end
    end
  end
end

require "monadic_expr"

describe MonadicExpr do
end
