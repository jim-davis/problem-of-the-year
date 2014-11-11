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

@verbose = false

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


def find_expressions(digits, filter)
  p = digits.permutation
  puts "#{p.count} permutations of the digits" if @verbose

  # all possible operand sequences
  lc = p.collect_concat{|sequence| lexical_combinations(sequence)}

  operands = lc.map{|l| l.map{|d| Digit.new(d)}}
  puts "#{operands.length} operand sequences" if @verbose

  exprs = operands.collect_concat{|o| build_expressions(o)}

  exprs.uniq!
  puts "#{exprs.length} unique expressions" if @verbose

  evaluate_expressions(exprs, filter)

end

def solve(digits, &filter)
  print_result(find_expressions(digits, filter))
end

def print_result(value_expressions)
  value_expressions.keys.sort.each do |k|
    puts "#{k}: #{value_expressions[k].first}" + 
      ((value_expressions[k].length > 1) ? " plus #{value_expressions[k].length - 1} more" : "")
  end
  found = value_expressions.keys.sort
  missing = (1..found.max).reject {|i| found.find{|elt| elt == i}}
  if missing.length > 0
    puts "Missing: #{missing.inspect}"
  end
end


if __FILE__ == $0

  require 'optparse'

  options = {max: 100,
    digits: %w(1 2 4 9),
    only: nil
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: find-expressions.rb [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:verbose] = v
    end

    opts.on("--max M", "max number to solve for") do |v|
      options[:max] = v.to_i
    end
    opts.on("--digits 1234", "digits to use") do |v|
      options[:digits] = v.split("")
    end
    opts.on("--only D", "show only solutions for D") do |v|
      options[:only] = v.to_i
    end
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

  end.parse!

  r = find_expressions( options[:digits], Proc.new{|v| v >= 1 && v <= options[:max] && v.floor == v})

  if options[:only]
    r[options[:only]].each{|expr| puts expr.to_s}
  else
    print_result(r)
  end

end

