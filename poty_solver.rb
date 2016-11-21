class PotySolver
  attr_reader :stats, :allow_permutations, :results, :range, :verbose
  def initialize(statistics, options)
    @stats = statistics
    @allow_permutations = options[:allow_permutations]
    @verbose = options[:verbose]
  end

  # Given a list of digits and a range, return a hash where key is a whole number and the 
  # value is the set of expressions 
  # that evaluate to that number
  def solve(digits, range)
    stats.start
    @range = range
    @results = Hash.new{|h, k| h[k]=[]}
  end

  def interesting?(v)
    !v.nil? && v.is_Integer? && range.include?(v.floor)
  end

  def add_result(v, expr) 
    v = v.floor
    if !results.has_key?(v) 
      stats.got_value(v)
    end
    results[v] << expr
  end

  def complete?
    nsolved.eql?(range.count)
  end
  
  def nsolved
    results.keys.length
  end

end
