class Statistics
  def initialize(verbose)
    @verbose = verbose
    @countFound = 0
  end

  def start
    @startTime = Time.now
    @expressionCount = 0
    @evaluationCount = 0
    @errorCount = 0
  end

  def report
    puts "Generated #{@expressionCount} expressions.  Evaluated #{@evaluationCount}.  Found #{@countFound} answers in #{Time.now - @startTime} seconds"
  end


  def got_value(v)
    @countFound +=1
  end

  def setProgressMax(n)
    @n = n
  end

  def setProgress(i)
    puts "#{(Float(i) * 100/@n).floor}% examined.  #{@expressionCount} expressions checked. #{@errorCount} errors.  #{@countFound} answers found"
  end

  def countExpression
    @expressionCount +=1
  end

  def countEvaluation
    @evaluationCount += 1
  end

  def countError
    @errorCount += 1
  end


end


