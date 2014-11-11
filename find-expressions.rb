#!/c/Ruby193/bin/ruby

# Todo
# remove duplicates 
#   normalized: use commutative to put lessor arg first.
#   use associative law
# print should use braces only when needed

$LOAD_PATH << Dir.pwd

require "util"
require "expressions"
require "operators"
#require "pry"

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

# given a list of operands return all possible expressions over those operands
def build_expressions(operands)
  right_associative_tree(operands) + left_associative_tree(operands)
end

#FIXME.  It's very ugly how much repetition is in  right_associative_tree
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
        if !op.noop?(lhs, rhs)
          list.add(BinaryExpression.new(op, lhs, rhs))
        end
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
        if !op.noop?(lhs, rhs)
          list.add(BinaryExpression.new(op, lhs, rhs))
        end
      end
    end
  end
  list
end

# Given a list of expressions, evaluate them
# filtering for those whoe value passes the filter
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
  p = digits.permutation
  puts "#{p.count} permutations of the digits" if @verbose

  # all possible operand sequences.  We can combine digits, e.g. "2" and "3" make "23"
  lc = p.collect_concat{|sequence| lexical_combinations(sequence)}
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
      puts "#{k}: #{value_expressions[k].first}" + 
        ((value_expressions[k].length > 1) ? " plus #{value_expressions[k].length - 1} more" : "")
    end
    found = value_expressions.keys.sort
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
    r[options[:only]].each{|expr| puts expr.to_s}
  else
    print_result(r)
  end

end

