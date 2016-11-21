require "monadic_expression"

describe MonadicExpression do
  before(:each) do
    @op  =  double("operand")
    allow(@op).to receive(:depth) {7}
    allow(@op).to receive(:leaves) {[@op]}
    allow(@op).to receive(:add_right_ancestor)
    allow(@op).to receive(:add_left_ancestor)
    allow(@op).to receive(:value) {0}
    @operator = double("operator")
    allow(@operator).to receive(:evaluate).with([0]) {1}
  end
  it "has depth 1 greater than depth of its operand" do
    expr = MonadicExpression.new(@operator, @op)
    expect(expr.depth).to eq(8)
  end

end
