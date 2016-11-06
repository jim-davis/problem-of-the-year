class Noop < Exception
end

class Operator
  attr_reader :symbol, :f, :inverse
  def initialize(symbol, precedence, f, op_position, associative=false, commutative=false, inverse=nil)
    @symbol = symbol
    @precedence = precedence
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
  def opCount
    1
  end
  # syntactic check.  for example, you can concatenate Digits, but not expressions.
  # This does not (and can not) check values of expressions, e.g. sqrt(negative)
  def applies_to?(x)
    true
  end
end

class MonadicOperator < Operator
  def evaluate(operands)
    f.call(operands[0])
  end
  def applies_to?(x)
    true
  end
  def expression_string(parent_precedence, operand)
    if postfix?
      operand.stringify(@precedence) + @symbol
    else
      @symbol +
        "(" +
        operand.stringify(@precedence) +
        ")"
    end
  end
end

class BinaryOperator < Operator
  def evaluate(operands)
    f.call(operands[0], operands[1])
  end
  def applies_to?(x, y)
    true
  end
  def expression_string(parent_precedence, operand1, operand2)
    if prefix?
      @symbol + 
        "(" + 
        operand1.stringify(@precedence) + 
        "," +
        operand2.stringify(@precedence) +
        ")"
    else
      brackets = parent_precedence > @precedence || 
        parent_precedence == @precedence && !@is_associative
      (brackets ? "(" : "") + 
        operand1.stringify(@precedence) +
        " " + @symbol + " " +
        operand2.stringify(@precedence) +
        (brackets ? ")" : "")
    end
  end
end

#------------

binary_operators = []

Plus = BinaryOperator.new("+", 1, Proc.new {|op1, op2| op1 + op2}, :IN, true, true)
Times = BinaryOperator.new("x", 2, Proc.new {|op1, op2| op1 * op2}, :IN, true, true)
Minus = BinaryOperator.new("-", 0, Proc.new {|op1, op2| op1 - op2}, :IN, false, false)
Divide = BinaryOperator.new("/", 3, Proc.new {|op1, op2| Float(op1) / op2}, :IN, false, false)


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

binary_operators << Plus
binary_operators << Times
binary_operators << Minus
binary_operators << Divide

Expt = BinaryOperator.new("**", 4, Proc.new {|op1, op2| safe_expt(op1, op2)}, :IN)

def safe_expt(op1, op2)
  raise RangeError.new("Exponent power #{op2} is negative") if op2 < 0
  raise RangeError.new("Exponent power #{op2} must be integer") if ! op2.is_a? Integer
  raise RangeError.new("Exponent power #{op2} too large")  if op2 > 8
  raise RangeError.new("Exponent #{op1} power #{op2} too large") if op1 * op2 > 20
  op1 ** op2
end

class << Expt
end

binary_operators << Expt

# Glues two digits together.  It only applies to Digits
Concat = BinaryOperator.new("C", 99, Proc.new{|d1, d2| (d1.to_s + d2.to_s).to_i}, :IN)

class << Concat
  def expression_string(parent_precedence, operand1, operand2)
    evaluate([operand1, operand2]).to_s
  end
  def applies_to?(x, y)
    (x.is_a? Digit) && (y.is_a? Digit)
  end
  def opCount
    0
  end
end

binary_operators << Concat

BINARY_OPERATORS = binary_operators

monadic_operators = []

Fact = MonadicOperator.new("!", 6, Proc.new { |op| safe_factorial(op)}, :POST)

def safe_factorial(x) 
  raise Noop if (x == 0 || x == 1 || x == 2)
  if x < 1 || !x.is_a?(Fixnum)
    raise RangeError.new("Factorial defined on whole numbers > 0, not #{x}")
  end
  if x > 10
    raise RangeError.new("Factorial argument #{x}! is too big")
  end
  factorial(x)
end

def factorial(x)
  x == 1 ? 1 : x * factorial(x-1)
end

monadic_operators << Fact


Sqrt = MonadicOperator.new("sqrt", 6, Proc.new { |op| safe_sqrt(op) }, :PRE)

def safe_sqrt(x)
  raise Noop if x == 0
  raise Noop if x == 1
  raise RangeError.new("Sqrt no complex arithmetic. sqrt(#{x})") if x < 0
  raise RangeError.new("Sqrt only for integers, not #{x}") if ! x.is_a? Integer
  # for our purposes we only want square roots that are integers
  v = Math.sqrt(x)
  i = v.to_i
  # This isn't completely right, since sqrt(x)**2 == x and it might be a useful way to get rid of a 2
  raise RangeError.new("Sqrt only integer-valued square roots useful.  sqrt(#{x}= #{v}") if ! (v == i) 
  i
end

monadic_operators << Sqrt


Decimalize = MonadicOperator.new(".", 10, Proc.new { |op| op * 0.1 }, :PRE)
class << Decimalize
   def applies_to?(x)
    (x.is_a? Digit)
  end
  def expression_string(parent_precedence, operand)
    "." + operand.stringify(@precedence) 
  end
end

monadic_operators << Decimalize

# This is very ad-hoc.  only .9_ is allowed
RepeatingDecimal = MonadicOperator.new(".", 10, Proc.new { |op| 1 }, :PRE)
class << RepeatingDecimal
  def applies_to?(x)
     (x.is_a? Digit) && x.value == 9
   end
   def expression_string(parent_precedence, operand)
     "." + operand.stringify(@precedence) + "_"
   end
 end

monadic_operators << RepeatingDecimal

PrefixMinus = MonadicOperator.new("-", 12, Proc.new{ |op| 0 - op}, :PRE)
class << PrefixMinus
   def expression_string(parent_precedence, operand)
     "-" + operand.stringify(@precedence)
   end

 end

monadic_operators << PrefixMinus

MONADIC_OPERATORS = monadic_operators
