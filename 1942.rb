#!/c/Ruby193/bin/ruby

# Todo
# remove duplicates 
#   sort by (normalized-form) order 
#   normalized: use commutative to put lessor arg first.
#   use associative law
# print should use braces only when needed

$LOAD_PATH << Dir.pwd

require "util"
require "expressions"
require "operators"
require "pry"

# Given a list of strings, e.g. ["1", "2", "3"]
# return all the ways these can be combined as strings
# e.g. [["1", "2", "3"] (no combination), ["1", "23"], ["12", "3"], ["123"]]
def lexical_combinations(operands)
  l = []
  if operands.length == 1
    l.add(operands)
  else
    digit = operands.first
    lexical_combinations(operands.butfirst).each do |tail|
      l.add([digit] + tail)     # keep separate or
      l.add([digit + tail.first] + tail.butfirst) # combine first and second
      end
    l
  end
end

# given a list of operands return all possible expressions
def build_expressions(operands)
  right_associative_tree(operands) + left_associative_tree(operands)
end

def right_associative_tree(operands)
  list = []
  if operands.length == 1
    list.add(operands.first)
    list.add(MonadicExpression.new(Fact, operands.first))
  else
    lhs = operands.first
    build_expressions(operands.butfirst).each do |rhs|
      list.add(BinaryExpression.new(Plus, lhs, rhs))
      list.add(BinaryExpression.new(Times, lhs, rhs))
      list.add(BinaryExpression.new(Minus, lhs, rhs))
      list.add(BinaryExpression.new(Divide, lhs, rhs))
      list.add(BinaryExpression.new(Expt, lhs, rhs))
    end
  end
  list
end

def left_associative_tree(operands)
  list = []
  if operands.length == 1
    list.add(operands.first)
    list.add(MonadicExpression.new(Fact, operands.first))
  else
    rhs = operands.pop
    build_expressions(operands).each do |lhs|
      list.add(BinaryExpression.new(Plus, lhs, rhs))
      list.add(BinaryExpression.new(Times, lhs, rhs))
      list.add(BinaryExpression.new(Minus, lhs, rhs))
      list.add(BinaryExpression.new(Divide, lhs, rhs))
      list.add(BinaryExpression.new(Expt, lhs, rhs))
    end
  end
  list
end


def evaluate_expressions(exprs, filter)
  value_expressions = Hash.new{|h, k| h[k]=[]}
  exprs.each do |expr| 
    v = nil
    begin
      v = expr.evaluate
      if filter.call(v)
        value_expressions[v.floor] << expr
      else
      end
    rescue Exception => e
      #STDERR.puts "Eval #{expr} caused #{e}"
    end
  end
  value_expressions
end

def print_result(value_expressions)
  value_expressions.keys.sort.each do |k|
    puts "#{k}: #{value_expressions[k].first}" + 
      ((value_expressions[k].length > 1) ? " plus #{value_expressions[k].length - 1} more" : "")
  end
  found = value_expressions.keys.sort
  missing = (1..found.max).reject {|i| found.find{|elt| elt == i}}
  puts "Missing: #{missing.inspect}"
end

def find_expressions(digits, &filter)
  p = digits.permutation
  puts "#{p.count} permutations of the digits"

  # all possible operand sequences
  lc = p.collect_concat{|sequence| lexical_combinations(sequence)}

  operands = lc.map{|l| l.map{|d| Digit.new(d)}}
  puts "#{operands.length} operand sequences"

  exprs = operands.collect_concat{|o| build_expressions(o)}

  puts "#{exprs.length} expressions.  Testing them all"

  print_result( evaluate_expressions(exprs, filter))

end




if __FILE__ == $0
#  find_expressions(%w(4 4 4 4)){|v| v >= 1 && v <= 20 && v.floor == v}
  find_expressions(%w(1 9 4 2)){|v| v >= 1 && v <= 100 && v.floor == v}
end

