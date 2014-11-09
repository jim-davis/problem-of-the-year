#!/c/Ruby193/bin/ruby

# todo remove duplicates
# sort by (normalized-form) order 
# normalized: use commutative to put lessor arg first.
# evaluate and store by result
# remove those that are not whole numbers > 0 <=100
# print with braces but only when needed

require "util"
require "expressions"
require "operators"
require "pry"

# Given a list of operands, e.g. ["1", "2", "3"]
# return all the ways these can be combined lexically in order
# e.g. [["1", "2", "3"], ["1", "23"], ["12", "3"], ["123"]]
def operand_combinations(operands)
  if operands.length == 1
    [operands]
  else
    l = []
    lhs = operands[0]
    operand_combinations(operands.except(lhs)).each do |rhs|
      if !rhs.is_a?(Array)
        binding.pry
      end
      if rhs.is_a?(Array)
        l << [lhs] + rhs
      end
      l << [lhs + rhs[0]] + rhs[1..rhs.length]
      end
    l
  end
end

def build_expressions(operands)
  list = []
  if operands.length == 1
    [Digit.new(operands[0])]
  else
    COMMUTATIVE_BINARY_OPERATORS.each do |op|
    end
  end
  list
end

if __FILE__ == $0
  digits = %w{1 2 3 4}
  #permutations(%w(1 2 3 4)).each{|p| puts puts "#{p.inspect}"}
  operand_combinations(digits).each{|e| puts "#{e.inspect}"}
  exprs = build_expressions(operand_combinations(digits))
  #exprs.each do |e| puts "#{e} => #{e.evaluate}" end

end
