require "expressions"
require "operators"

# Fixme: assumes there are four digits
def generate_expressions(digits, allow_permutations, stats) 
  i = 0

  digit_sets = allow_permutations ? digits.permutation : [digits]
  stats.setProgressMax(digit_sets.count)

  digit_sets.each do |operands|

    # I tried different ways of generating the expressions.
    # I suppose the third way is the clearest, but none of them are very clear.
    # There really should be a more compact notation for this, which then gets intepreted to generate
    # the loop structure.  And some systematic way of ensuring we generate all types of tree

    d = operands.map{|digit| monadic_expressions_over(Digit.new(digit))}

    # symmetric tree ((0 1) (2 3))
    binary_expressions_over(d[0], d[1]).each {|b01|
      binary_expressions_over(d[2], d[3]).each {|b23|
        binary_expressions_over(b01, b23).each {|expr| yield(expr)}}}
      
    # left associative tree (((0 1) 2) 3) 
    binary_expressions_over(d[0], d[1]).each {|b01|
      binary_expressions_over(b01, d[2]).each {|b012|
        binary_expressions_over(b012, d[3]).each {|expr| yield(expr)}}}

    # We don't *need* this tree, at least not for 1468
    if false
    # right associative tree (0 (1 (2 3)))
    binary_expressions_over(d[2], d[3]).each {|b23|
      binary_expressions_over(d[1], b23).each {|b123|
        binary_expressions_over(d[0], b123).each {|expr| yield(expr)}}}
    end

    # We don't *need* this tree, at least not for 1468
    if false
    # another tree ((0 (1 2)) 3)
    binary_expressions_over(d[1], d[2]).each {|b12|
      binary_expressions_over(d[0], b12).each {|b012|
        binary_expressions_over(b012, d[3]).each {|expr| yield(expr)}}}
    end

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
  (op1.kind_of?(Array) ? op1 : [op1]).flat_map {|l|
    (op2.kind_of?(Array) ? op2 : [op2]).flat_map {|r|
      BINARY_OPERATORS
        .select {|op| op.applies_to?(l, r)}
        .flat_map { |op| monadic_expressions_over(BinaryExpression.new(op, l, r))}
    }}
end
