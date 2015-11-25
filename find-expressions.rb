#!/c/Ruby193/bin/ruby

$LOAD_PATH << Dir.pwd

require "util"
require "expressions"
require "operators"
require "generate"
require "optparse"
require "statistics"

@show_errors = false

def main
  options = {
    digits: %w(1 4 6 8),
    max: 100,
    only: nil,
    show_all: false,
    show_errors: false
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
    opts.on("--show-all", "show all results, not just first")  do |v|
      options[:show_all] = v
    end
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

  end.parse!

  @show_errors = options[:show_errors]

  stats = Statistics.new(options[:verbose])

  stats.start
  r = find_expressions( options[:digits], 1..options[:max], stats)
  stats.report

  if options[:only]
    r[options[:only]].sort_by{|e| e.opCount}.each{|expr| puts expr.to_s}
  else
    print_results(r, options[:show_all])
  end
end

# Given a list of digits and a range, return a hash where key is a whole number and the 
# value is the set of expressions (constructed using only those digits)
# that evaluate to that number, which must  be in the range.
# Also takes a instance of Statistics, used to report progress and collect statistics.
def find_expressions(digits, range, stats)
  value_expressions = Hash.new{|h, k| h[k]=[]}
  generate_expressions(digits, stats) do |expr|
    v = nil
    begin
      v = expr.evaluate
      if v.is_Integer?
        v = v.floor
        if range.include?(v)
          if !value_expressions.has_key?(v) 
            stats.got_value(v)
          end
          value_expressions[v] << expr
        end
      end
    rescue RangeError => e
      # Several operators raise RangeError to stop processing, e.g. for factorial
      # ignore
    rescue Exception => e
      STDERR.puts "Eval #{expr} caused #{e}" if @show_errors
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
