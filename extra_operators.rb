Log = BinaryOperator.new("log", 5, Proc.new {|n, base| safe_log(base, n)}, :PRE)

def safe_log(base, n)
  if n <= 0 
    raise RangeError.new("log power must be positive")
  end
  if base < 1 && n != 1
    raise RangeError.new("Log Base must be >= 1")
  end
  Math.log(n, base)
end

class << Log
end

Mod = BinaryOperator.new("mod", 5, Proc.new {|n, base| safe_mod(n, base)}, :PRE)

def safe_mod(n, base)
  if base <= 0
    raise RangeError.new("Mod base must be positive")
  end
  n % base
end
    
class << Mod
end

Abs = MonadicOperator.new("|", 6, Proc.new { |op| op.abs }, :PRE)
class << Abs
  def noop? (x)
    x.is_a?(Digit) && x.value >= 0
  end
  def expression_string (operand)
    "|#{operand}|"
  end
end






