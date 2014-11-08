digits = %w{1 9 4 2}

COMMUTATIVE_BINARY_OPERATORS = %w{+ *}
ORDERED_BINARY_OPERATORS = %w{- /}

def binary_operations(a, b)
  if a.is_a?(String) && b.is_a?(String)
    yield(a+b)
    yield(b+a)
  end
  COMMUTATIVE_BINARY_OPERATORS.each do |op|
    yield([a, op, b])
  end
  return
  ORDERED_BINARY_OPERATORS.each do |op|
    yield("#{a} #{op} #{b}")
  end
  ORDERED_BINARY_OPERATORS.each do |op|
    yield("#{b} #{op} #{a}")
  end
end

def generate_expressions(operands)
  operands.each do |op|
    others = operands - [op]
    generate_expressions2(op, others){|x| yield(x)}
  end
end

def generate_expressions2(a, others)
  binary_operations(a, others.first){|x| yield(x)}
end
  
#binary_operations(digits.first, digits[1]){|s| puts s}

generate_expressions(digits){|s| puts s.respond_to?(:join) ? s.join(" ") : s}

