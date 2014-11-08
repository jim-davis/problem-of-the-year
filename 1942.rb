#!/c/Ruby193/bin/ruby
digits = %w{1 9 4 2}

COMMUTATIVE_BINARY_OPERATORS = %w{+ *}
ORDERED_BINARY_OPERATORS = %w{- /}

class Array
  def except(elt)
    self - [elt]
  end
end


def binary_combinations(a, b)
  list=[]
  if a.is_a?(String) && b.is_a?(String)
    list << a+b
    list << b+a
  end
  COMMUTATIVE_BINARY_OPERATORS.each do |op|
    list << [a, op, b]
  end
  ORDERED_BINARY_OPERATORS.each do |op|
    list << [a, op, b]
  end
  ORDERED_BINARY_OPERATORS.each do |op|
    list << [a, op, b]
  end
  list
end

def generate_expressions(operands)
  if operands.length == 1
    operands
  else
    l = []
    operands.each do |lhs|
      generate_expressions(operands.except(lhs)).each do |rhs|
        l+= binary_combinations(lhs, rhs)
      end
    end
    l
  end
end

def stringify(expr)
  expr.respond_to?(:join) ? expr.join(" ") : expr
end

# FIXME: sort and remove duplicates

generate_expressions(digits).each{|e| puts stringify(e)}
