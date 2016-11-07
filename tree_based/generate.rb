require "expressions"
require "operators"

# Fixme: assumes there are four digits
def generate_expressions(digits, allow_permutations, stats) 
  digit_sets = allow_permutations ? digits.permutation : [digits]
  digit_sets_examined = 0
  stats.setProgressMax(digit_sets.count) if allow_permutations

  digit_sets.each do |operands|

    # These generators are hard to understand.
    # There really should be a more compact notation for this, which then gets intepreted to generate
    # the loop structure.  And some systematic way of ensuring we generate all types of tree.
    # I *think* I have them all.

    # I expect to generate 25,000,000 expressions.  
    # For each digit there are (typically) 5 monadic expressions
    # so the set of all binary expressions over two digits is about 4 * 5 * 5^2 ==> 500
    # binary expressions on those binary expressions: 4 * 5 * 500**2
    # 5 shapes of trees, thus
    # 5 * (4 * 5 * (4 * 5 * 5**2)**2)
    # The real count is higher, since monadic repeating decimal operator applies to digit 9

    d = operands.map{|digit| monadic_expressions_over(Digit.new(digit))}

    expressions_over(d[0], d[1]).each {|b01|
      #  ((0 1) (2 3))
      expressions_over(d[2], d[3]).each {|b23|
        expressions_over(b01, b23).each {|expr| yield(expr)}}
      
      # (((0 1) 2) 3)
      expressions_over(b01, d[2]).each {|b012|
        expressions_over(b012, d[3]).each {|expr| yield(expr)}}
    }

    expressions_over(d[1], d[2]).each {|b12|

      # ((0 (1 2)) 3)
      expressions_over(d[0], b12).each {|b012|
        expressions_over(b012, d[3]).each {|expr| yield(expr)}}

      # (0 ((1 2) 3))
      expressions_over(b12, d[3]).each {|b123|
        expressions_over(d[0], b123).each {|expr| yield(expr)}}
    }

    #  (0 (1 (2 3)))
    expressions_over(d[2], d[3]).each {|b23|
      expressions_over(d[1], b23).each {|b123|
        expressions_over(d[0], b123).each {|expr| yield(expr)}}}

    if allow_permutations
      digit_sets_examined += 1
      stats.setProgress(digit_sets_examined)
    end
  end
end

# A list of all expressions formed by combining 
# * all (applicable) monadic operators composed over
# * all binary operators applied to 
# * every *pair* of operands taken from the lists op1 and op2
# so if there are two monadic operators, three binary operators, and 
# five values in each op list, this yields (2 + 1) * 3 * (5^2) expressions
# The +1 for monadic is because we also consider the "empty" monadic operator
def expressions_over(op1, op2)
  expressions_over_lists( asArray(op1), asArray(op2))
end

def expressions_over_lists(op1, op2)
  op1.flat_map {|l|
    op2.flat_map {|r|
      BINARY_OPERATORS
        .select {|op| op.applies_to?(l, r)}
        .flat_map { |op| monadic_expressions_over(BinaryExpression.new(op, l, r))}
    }}
end

# Return a list of expressions formed by applying the allowable monadic
# operators to the operand plus the operand itself (the "null operator")
# In theory one could apply more than one monadic operator, e.q. Fact(Sqrt(x))
# but this makes the tree of possible expressions so large that the program
# runs all night.  I halted it after 231 million expressions.
def monadic_expressions_over(operand)
  [operand] + 
    MONADIC_OPERATORS
    .select { |op| op.applies_to?(operand)}
    .map { |op| MonadicExpression.new(op, operand) }
end
