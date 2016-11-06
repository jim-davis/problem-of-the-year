require "expressions"
require "operators"

# Fixme: assumes there are four digits
def generate_expressions(digits, allow_permutations, stats) 
  i = 0

  digit_sets = allow_permutations ? digits.permutation : [digits]
  stats.setProgressMax(digit_sets.count)

  digit_sets.each do |operands|

    # I'm the first to admit that these generators are hard to understand
    # There really should be a more compact notation for this, which then gets intepreted to generate
    # the loop structure.  And some systematic way of ensuring we generate all types of tree.
    # I *think* I have them all.

    d = operands.map{|digit| monadic_expressions_over(Digit.new(digit))}

    #  ((0 1) (2 3))
    binary_expressions_over(d[0], d[1]).each {|b01|
      binary_expressions_over(d[2], d[3]).each {|b23|
        binary_expressions_over(b01, b23).each {|expr| yield(expr)}}}

    #  (((0 1) 2) 3)
    binary_expressions_over(d[0], d[1]).each {|b01|
      binary_expressions_over(b01, d[2]).each {|b012|
        binary_expressions_over(b012, d[3]).each {|expr| yield(expr)}}}

    # ((0 (1 2)) 3)
    binary_expressions_over(d[1], d[2]).each {|b12|
      binary_expressions_over(d[0], b12).each {|b012|
        binary_expressions_over(b012, d[3]).each {|expr| yield(expr)}}}

    # (0 ((1 2) 3))
    binary_expressions_over(d[1], d[2]).each {|b12|
      binary_expressions_over(b12, d[3]).each {|b123|
        binary_expressions_over(d[0], b123).each {|expr| yield(expr)}}}

    # right associative tree (0 (1 (2 3)))
    binary_expressions_over(d[2], d[3]).each {|b23|
      binary_expressions_over(d[1], b23).each {|b123|
        binary_expressions_over(d[0], b123).each {|expr| yield(expr)}}}
      
    i+=1
    stats.setProgress(i)
  end

end

# Arbitrarily decided to allow at most two levels of monadic functional composition
def monadic_expressions_over(operand)
  [operand] + MONADIC_OPERATORS
    .select { |op| op.applies_to?(operand)}
    .map { |op| MonadicExpression.new(op, operand) }
end

def binary_expressions_over(op1, op2)
  (op1.kind_of?(Array) ? op1 : [op1]).flat_map {|l|
    (op2.kind_of?(Array) ? op2 : [op2]).flat_map {|r|
      BINARY_OPERATORS
        .select {|op| op.applies_to?(l, r)}
        .flat_map { |op| monadic_expressions_over(BinaryExpression.new(op, l, r))}
    }}
end
