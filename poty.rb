# TODO 
# Does not find a solution for 59 for the digits 1492.  I must be missing something.
# Maybe try the simplest tree first, and only try others if we don't get them all
# Known limitation: there must be exactly four digits

$LOAD_PATH << Dir.pwd

require "statistics"
require "optparse"
autoload :PotySolver, "poty_solver.rb"
autoload :TreePotySolver, "tree_solver.rb"
autoload :GraphPotySolver, "graph_solver.rb"


def main
  options = {
    digits: nil,
    max: 100,
    only: nil,
    show_all: false,
    permutations: false,
    algorithm: :graph
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: poty.rb [options]"

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
    opts.on("--[no-]permutations", "allow permutations of digits") do |v|
      options[:permutations] = v
    end
    opts.on("--show-all", "show all results, not just first")  do |v|
      options[:show_all] = v
    end

    opts.on("--tree", "use tree-generation algorithm") do |v|
      options[:algorithm] = :tree
    end
    opts.on("--graph", "use graph-exploration algorithm") do |v|
      options[:algorithm] = :graph
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

  end.parse!

  if options[:digits].nil?
    STDERR.puts "Missing argument --digits" 
    exit 1
  end

  if options[:digits].count != 4
    STDERR.puts "You must provide exactly four digits." 
    exit 1
  end

  stats = Statistics.new(options[:verbose])

  solver = case options[:algorithm]
           when :tree
             TreePotySolver.new(stats, options)
           when :graph
             GraphPotySolver.new(stats, options)
           else
             raise "Unsupported solver algorithm #{options[:algorithm]}"
           end
  
  range = 1..options[:max]
  r = solver.solve(options[:digits], range)

  stats.report
  if options[:only]
    r[options[:only]].each{|expr| puts expr.to_s}
  else
    print_results(r, options[:show_all], range)
  end
end

# print the results, either showing one expression or all
# If showing only one, pick the smallest one.
def print_results(value_expressions, show_all, range)
  if value_expressions.keys.length == 0
    puts "No solutions!"
  else
    value_expressions.keys.sort.each do |k|
      expressions = value_expressions[k]
      puts "#{k}: " + (show_all ? "#{expressions}" : 
        "#{expressions.first}" + 
        ((expressions.length > 1) ? " plus #{expressions.length - 1} more" : ""))
    end
    found = value_expressions.keys
    missing = range.reject {|i| found.find{|elt| elt == i}}
    if missing.length > 0
      puts "Missing: #{missing.inspect}"
    end
  end
end

if __FILE__ == $0
  main
end

