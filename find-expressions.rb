# TODO 
# Maybe try the simplest tree first, and only try others if we don't get them all
# Known limitation: there must be exactly four digits

$LOAD_PATH << Dir.pwd

require "util"
require "expressions"
require "operators"
require "generate"
require "optparse"
require "statistics"

@show_errors = true
@max_errors = 10

def main
  options = {
    digits: nil,
    max: 100,
    only: nil,
    show_all: false,
    show_errors: true,
    permutations: false,
    max_errors: 10
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
    opts.on("--[no-]permutations", "allow permutations of digits") do |v|
      options[:permutations] = v
    end
    opts.on("--[no-]show-errors", "show errors while evaluating") do |v|
      options[:show_errors] = v
    end
    opts.on("--max-errors n", "Stop if more than n errors arise") do |v|
      options[:show_errors] = true
      options[:max_errors] = v.to_i
    end
    opts.on("--show-all", "show all results, not just first")  do |v|
      options[:show_all] = v
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
    

  @show_errors = options[:show_errors]
  @max_errors = options[:max_errors]

  stats = Statistics.new(options[:verbose])

  stats.start
  catch (:error_limit) do
    r = find_expressions( options[:digits], 1..options[:max], options[:permutations], stats)
    stats.report

    if options[:only]
      r[options[:only]].sort_by{|e| e.opCount}.each{|expr| puts expr.to_s}
    else
      print_results(r, options[:show_all])
    end
  end
end

# Given a list of digits and a range, return a hash where key is a whole number and the 
# value is the set of expressions (constructed using only those digits)
# that evaluate to that number, which must  be in the range.
# Also takes a instance of Statistics, used to report progress and collect statistics.
def find_expressions(digits, range, allow_permutations, stats)
  value_expressions = Hash.new{|h, k| h[k]=[]}
  error_counter = 0
  generate_expressions(digits, allow_permutations, stats) do |expr|
    v = nil
    begin
      v = expr.evaluate
      stats.countExpression
      if v.is_a? Integer
        v = v.floor
        if range.include?(v)
          if !value_expressions.has_key?(v) 
            stats.got_value(v)
          end
          value_expressions[v] << expr
          if value_expressions.keys.length === range.count
            puts "Got them all.  Quitting"
            break
          end
        end
      end
    rescue RangeError => e
      # Several operators raise RangeError to stop processing, e.g. for factorial argument too large
      # ignore
    rescue Noop => e
      # The expression includes an operator that is a Noop, which means there is guaranteed to be
      # a simpler way to say the same thing
    rescue Exception => e
      STDERR.puts "Eval #{expr} caused #{e}" if @show_errors
      error_counter += 1
      if @max_errors && error_counter >= @max_errors
        STDERR.puts "Error limit reached.  Halting"
        throw :error_limit
      end
      stats.countError
    end
  end
  value_expressions
end

# print the results, either showing one expression or all
# If showing only one, pick the smallest one.
def print_results(value_expressions, show_all)
  if value_expressions.keys.length == 0
    puts "No solutions!"
  else
    value_expressions.keys.sort.each do |k|
      expressions = value_expressions[k].sort_by{|e| e.opCount}
      puts "#{k}: " + (show_all ? "#{expressions}" : 
        "#{expressions.first}" + 
        ((expressions.length > 1) ? " plus #{expressions.length - 1} more" : ""))
    end
    found = value_expressions.keys
    missing = (1..found.max).reject {|i| found.find{|elt| elt == i}}
    if missing.length > 0
      puts "Missing: #{missing.inspect}"
    end
  end
end

if __FILE__ == $0
  main
end
