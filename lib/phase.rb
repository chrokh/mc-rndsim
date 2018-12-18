require_relative 'csv'
require_relative 'dist'

class Phase
  attr_reader :time, :cost, :cash, :prob
  def initialize time, cost, cash, prob
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
    if prob <= 0 || prob > 1
      raise 'Probability of a phase outside range (0,1]!'
    end
  end
end

class PhasesParser
  def initialize data
    @data = data
  end
  def parse
    lines = CSVParser.new(@data).lines
    lines[0..lines.length-2].map do |line|
      PhaseDist.new(
        DistParser.new(line[0]).parse,
        DistParser.new(line[1]).parse,
        DistParser.new(line[2]).parse,
        DistParser.new(line[3]).parse,
      )
    end
  end
end
