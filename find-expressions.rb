#!/c/Ruby193/bin/ruby

# Todo
# remove duplicates 
#   normalized: use commutative to put lessor arg first.
#   use associative law

$LOAD_PATH << Dir.pwd

require "util"
require "expressions"
require "operators"

@verbose = false

# given a list of operands return all possible expressions over those operands
# using the hardcoded list of operators
def build_expressions(operands)
  right_associative_tree(operands) + left_associative_tree(operands)
end

#FIXME.  It's very ugly how much repetition is in right_associative_tree
# and left associative tree.  They only differ in whether the traverse the list fwd or back

def right_associative_tree(operands)
  list = []
  if operands.length == 1
    operand = operands.first
    list.add(operand)
    MONADIC_OPERATORS.each do |op|
      if !op.noop?(operand)
        list.add(MonadicExpression.new(op, operand))
      end
    end
  else
    lhs = operands.first
    build_expressions(operands.butfirst).each do |rhs|
      BINARY_OPERATORS.each do |op|
        list.add(BinaryExpression.new(op, lhs, rhs))
      end
    end
  end
  list
end

def left_associative_tree(operands)
  list = []
  if operands.length == 1
    operand = operands.first
    list.add(operand)
    MONADIC_OPERATORS.each do |op|
      if !op.noop?(operand)
        list.add(MonadicExpression.new(op, operand))
      end
    end
  else
    rhs = operands.pop
    build_expressions(operands).each do |lhs|
      BINARY_OPERATORS.each do |op|
        list.add(BinaryExpression.new(op, lhs, rhs))
      end
    end
  end
  list
end

# Given a list of expressions, evaluate them
# filtering for those whose value passes the filter
# Return a hash where the key is a whole number
# and the value is the set of expressions that produce that value.
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
    rescue RangeError => e
      # Several operators raise RangeError to stop processing, e.g. for factorial
      # ignore
    rescue Exception => e
      STDERR.puts "Eval #{expr} caused #{e}"
    end
  end
  value_expressions
end

# Given a list of digits and a filter, return
# a hash where key is a whole number and the
# value is the set of expressions (constructed using only those digits)
# that evaluate to that number
def find_expressions(digits, filter)
  # all possible operand sequences.  We can combine digits, e.g. "2" and "3" make "23"
  lc = lexical_combinations(digits)
  operands = lc.map{|l| l.map{|d| Digit.new(d)}}
  puts "#{operands.length} operand sequences" if @verbose

  # build expressions on the operands
  exprs = operands.collect_concat{|o| build_expressions(o)}
  exprs.uniq!
  puts "#{exprs.length} unique expressions" if @verbose

  evaluate_expressions(exprs, filter)

end

def solve(digits, &filter)
  print_result(find_expressions(digits, filter))
end

def print_result(value_expressions)
  if value_expressions.keys.length == 0
    puts "No solutions!"
  else
    value_expressions.keys.sort.each do |k|
      expressions = value_expressions[k].sort_by{|e| e.depth}
      puts "#{k}: #{expressions.first}" + 
        ((value_expressions[k].length > 1) ? " plus #{value_expressions[k].length - 1} more" : "")
    end
    found = value_expressions.keys
    missing = (1..found.max).reject {|i| found.find{|elt| elt == i}}
    if missing.length > 0
      puts "Missing: #{missing.inspect}"
    end
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
    opts.on("--[no-]show-errors", "show errors while evaluating") do |v|
      options[:show_errors] = v
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

  end.parse!

  @verbose = options[:verbose]
  
  r = find_expressions( options[:digits], Proc.new{|v| v >= 1 && v <= options[:max] && v.floor == v})

  if options[:only]
    r[options[:only]].sort_by{|e| e.depth}.each{|expr| puts expr.to_s}
  else
    print_result(r)
  end

end

