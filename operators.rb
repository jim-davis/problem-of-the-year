class Operator
  attr_reader :symbol, :f, :inverse
  def initialize(symbol, f, op_position, associative=false, commutative=false, inverse=nil)
    @symbol = symbol
    @f = f
    @op_position = op_position
    @is_associative = associative 
    @is_commutative = commutative
    @inverse = inverse
  end
  def prefix?
    @op_position == :PRE
  end
  def postfix?
    @op_position == :POST
  end
  def infix?
    @op_position == :IN
  end
  def associative?
    @is_associative
  end
  def commutative?
    @is_commutative
  end
end

class MonadicOperator < Operator
  def evaluate(operands)
    f.call(operands[0])
  end
  def noop?(x)
    false
  end
end

class BinaryOperator < Operator
  def evaluate(operands)
    f.call(operands[0], operands[1])
  end
  def noop?(x, y)
    false
  end
end

#------------

Plus = BinaryOperator.new("+", Proc.new {|op1, op2| op1 + op2}, :IN, true, true)
Times = BinaryOperator.new("x", Proc.new {|op1, op2| op1 * op2}, :IN, true, true)
Minus = BinaryOperator.new("-", Proc.new {|op1, op2| op1 - op2}, :IN, false, false)
Divide = BinaryOperator.new("/", Proc.new {|op1, op2| Float(op1) / op2}, :IN, false, false)

class << Plus
  @inverse = Minus
end

class << Minus
  @inverse = Plus
end

class << Times
  @inverse = Divide
end

class << Divide
  @inverse = Times
end


Expt = BinaryOperator.new("**", Proc.new {|op1, op2| safe_expt(op1, op2)}, :PRE)

def safe_expt(op1, op2)
  if op2 > 10
    raise RangeError.new("Exponent power #{op2} too large")
  end
  if op1 * op2 > 20
    raise RangeError.new("Exponent #{op1} power #{op2} too large")
  end
  op1 ** op2
end

class << Expt
  def noop? (x, y)
    x.is_a?(Digit) && x.value == 1
  end
end

BINARY_OPERATORS = [Plus, Times, Minus, Divide, Expt]

Fact = MonadicOperator.new("!", Proc.new { |op| factorial(op)}, :POST)

class << Fact
  def noop? (x)
    x.is_a?(Digit) && (x.value == 1 || x.value == 2)
  end
end

def factorial(x) 
  if x < 1 || !x.is_a?(Fixnum)
    raise RangeError.new("factorial is only defined on whole numbers > 0, not #{x}")
  end
  if x > 10
    raise RangeError.new("#{x}! is too big")
  end
  x == 1 ? 1 : x * factorial(x-1)
end

Sqrt = MonadicOperator.new("sqrt", Proc.new { |op| Math.sqrt(op) }, :PRE)
class << Sqrt
  def noop? (x)
    x.is_a?(Digit) && x.value == 1
  end
end

MONADIC_OPERATORS = [Fact, Sqrt]
