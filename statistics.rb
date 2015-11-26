class Statistics
  def initialize(verbose)
    @verbose = verbose
    @countFound = 0
  end

  def start
    @startTime = Time.now
    @expressionCount = 0
  end

  def report
    puts "Elapsed #{Time.now - @startTime} seconds"
  end

  def got_value(v)
    @countFound +=1
  end

  def setProgressMax(n)
    @n = n
  end

  def setProgress(i)
    puts "#{(Float(i) * 100/@n).floor}% examined.  #{@expressionCount} expressions checked, #{@countFound} answers found"
  end

  def countExpression
    @expressionCount +=1
  end


end


