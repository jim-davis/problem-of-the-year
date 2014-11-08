digits = %w{1 9 4 2}

COMMUTATIVE_BINARY_OPERATORS = %w{+ *}
ORDERED_BINARY_OPERATORS = %w{- /}

class Array
  def except(elt)
    self - [elt]
  end
end

def binary_operations(a, b)
  l=[]
  if a.is_a?(String) && b.is_a?(String)
    l << a+b
    l << b+a
  end
  COMMUTATIVE_BINARY_OPERATORS.each do |op|
    l << [a, op, b]
  end
  return l
  ORDERED_BINARY_OPERATORS.each do |op|
    yield("#{a} #{op} #{b}")
  end
  ORDERED_BINARY_OPERATORS.each do |op|
    yield("#{b} #{op} #{a}")
  end

end

def generate_expressions(operands)
  l = []
  operands.each do |op|
    others = operands.except(op)
    b = generate_expressions2(op, others)
    l += b
  end
  l
end

def generate_expressions2(op, others)
  l = []
  others.each do |op2|
    l +=  binary_operations(op, op2)
    others.except(op2)
  end
  l
end
  
generate_expressions(digits).each{|expr| puts expr.respond_to?(:join) ? expr.join(" ") : expr}

