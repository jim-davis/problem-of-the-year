require "expressions"
require "operators"

# Fixme: assumes there are four digits
def generate_expressions(digits, stats) 
  i = 0
  stats.setProgressMax(digits.permutation.count)

  digits.permutation.each do |operands|

    # I tried different ways of generating the expressions.
    # I suppose the third way is the clearest, but none of them are very clear.
    # There really should be a more compact notation for this, which then gets intepreted to generate
    # the loop structure.  And some systematic way of ensuring we generate all types of tree

    lhs = monadic_expressions_over(Digit.new(operands[0])).
      flat_map {|op1| monadic_expressions_over(Digit.new(operands[1]))
        .flat_map {|op2| binary_expressions_over(op1, op2)}}

    rhs = monadic_expressions_over(Digit.new(operands[2]))
      .flat_map {|op1| monadic_expressions_over(Digit.new(operands[3]))
        .flat_map {|op2| binary_expressions_over(op1, op2)}}

    # symmetric tree ((0 1) (2 3))
    lhs.each {|lh| 
      rhs.each {|rh| 
        combined = binary_expressions_over(lh, rh)
        combined.each { |expr|
          ee = monadic_expressions_over(expr)
          ee.each { |e| yield(e)}
        }
      }
    }

    # left associative tree (((0 1) 2) 3)
    lhs.each {|lh|
      monadic_expressions_over(Digit.new(operands[2])).each{|op2|
        binary_expressions_over(lh, op2).each{|st|
          monadic_expressions_over(Digit.new(operands[3])).each {|op3|
            binary_expressions_over(st, op3).each {|b|
              monadic_expressions_over(b).each {|expr| yield(expr)}}}}}}
    
    # another tree ((0 (1 2)) 3)
    monadic_expressions_over(Digit.new(operands[1])).each{|op1|
      monadic_expressions_over(Digit.new(operands[2])).each{|op2|
        binary_expressions_over(op1, op2).each {|b12| 
          monadic_expressions_over(Digit.new(operands[0])).each{|op0|
            binary_expressions_over(op0, b12).each {|b123| 
              monadic_expressions_over(Digit.new(operands[3])).each{|op3|
                binary_expressions_over(b123, op3).each {|b|
                  monadic_expressions_over(b).each{|expr| yield(expr) }}}}}}}}

    # right associative tree (0 (1 (2 3)))
    monadic_expressions_over(Digit.new(operands[2])).each{|op2|
      monadic_expressions_over(Digit.new(operands[3])).each{|op3|
        binary_expressions_over(op2, op3).each {|b23| 
          monadic_expressions_over(Digit.new(operands[1])).each{|op1|
            binary_expressions_over(op1, b23).each {|b123| 
              monadic_expressions_over(Digit.new(operands[0])).each{|op0|
                binary_expressions_over(op0, b123).each{|b|
                  monadic_expressions_over(b).each{|expr| yield (expr)}}}}}}}}                  

    # (0 ((1 2) 3))

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
