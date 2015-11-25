require "expressions"
require "operators"

# Fixme: assumes there are four digits
def generate_expressions(digits, stats) 
  i = 0
  stats.setProgressMax(digits.permutation.count)
  digits.permutation.each do |operands|
    lhs = monadic_expressions_over(Digit.new(operands[0])).
      flat_map {|op1| monadic_expressions_over(Digit.new(operands[1]))
        .flat_map {|op2| binary_expressions_over(op1, op2)}}
    rhs = monadic_expressions_over(Digit.new(operands[2]))
      .flat_map {|op1| monadic_expressions_over(Digit.new(operands[3]))
        .flat_map {|op2| binary_expressions_over(op1, op2)}}

    lhs.each {|lh| 
      rhs.each {|rh| 
        combined = binary_expressions_over(lh, rh)
        combined.each { |expr|
          ee = monadic_expressions_over(expr)
          ee.each { |e| yield(e)}
        }
      }
    }

    lhs.each {|lh|
      monadic_expressions_over(Digit.new(operands[2])).each{|op2|
        binary_expressions_over(lh, op2).each{|st|
          monadic_expressions_over(Digit.new(operands[3])).each {|op3|
            binary_expressions_over(st, op3).each {|expr| yield(expr)}}}}}
      
    i+=1
    stats.setProgress(i)
  end
end

# Arbitrarily decided to allow at most two levels of monadic functional composition
def monadic_expressions_over(operand)
  MONADIC_OPERATORS.map { |op| MonadicExpression.new(op, operand) } + [operand]
  #MONADIC_OPERATORS.flat_map { |op2| first_level.map {|expr| MonadicExpression.new(op2, expr)}} + [operand]
end

def binary_expressions_over(op1, op2)
  BINARY_OPERATORS.select {|op| op.applies_to?(op1, op2)}. 
    map { |op| BinaryExpression.new(op, op1, op2)
  }
end
