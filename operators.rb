require "expressions"

Plus = CommutativeOperator.new("+", Proc.new {|op1, op2| op1 + op2})
Times = CommutativeOperator.new("x", Proc.new {|op1, op2| op1 * op2})
Minus = BinaryOperator.new("-", Proc.new {|op1, op2| op1 - op2})
Divide = BinaryOperator.new("/", Proc.new {|op1, op2| Float(op1) / op2})

def safe_expt(op1, op2)
  if op2 > 10
    raise ArgumentError.new("Exponent power #{op2} too large")
  else
    op1 ** op2
  end
end

Expt = BinaryOperator.new("expt", Proc.new {|op1, op2| safe_expt(op1, op2)})


Fact = PostfixOperator.new("!", Proc.new { |op| factorial(op)})

def factorial(x) 
  if x < 1 || !x.is_a?(Fixnum)
    raise ArgumentError.new("factorial is only defined on whole numbers > 0, not #{x}")
  end
  if x > 10
    raise ArgumentError.new("#{x}! is too big")
  end
  x == 1 ? 1 : x * factorial(x-1)
end



