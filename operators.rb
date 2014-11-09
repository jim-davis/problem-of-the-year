Plus = CommutativeOperator.new("+", Proc.new {|op1, op2| op1 + op2})
Times = CommutativeOperator.new("x", Proc.new {|op1, op2| op1 * op2})
Minus = BinaryOperator.new("-", Proc.new {|op1, op2| op1 - op2})
Divide = BinaryOperator.new("/", Proc.new {|op1, op2| Float(op1) / op2})
Expt = BinaryOperator.new("expt", Proc.new {|op1, op2| op1 ** op2})

COMMUTATIVE_BINARY_OPERATORS  = [Plus, Times]
ORDERED_BINARY_OPERATORS = [Minus, Divide, Expt]


# Fixme add Fact 
