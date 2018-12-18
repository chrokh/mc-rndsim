class Market
  attr_reader :time, :cost, :cash, :prob
  def initialize time, cost, cash, prob
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
  end
  def phases
    @time.to_i.times.map do |t|

      # cash (TODO: refactor into interpolation class and test)
      y2   = @cash / (@time + 1) * 2
      k    = y2 / @time
      cash = (t+1) * k

      # cost (TODO: refactor into interpolation class and test)
      y2   = @cost / (@time + 1) * 2
      k    = y2 / @time
      cost = (t+1) * k

      # prob (TODO: refactor into interpolation class and test)
      prob = @prob ** (1.0 / @time)

      Phase.new 1, cost, cash, prob
    end
  end
end

class MarketParser
  def initialize data
    @data = data
  end
  def parse
    line = CSVParser.new(@data).lines.last
    MarketDist.new(
      DistParser.new(line[0]).parse,
      DistParser.new(line[1]).parse,
      DistParser.new(line[2]).parse,
      DistParser.new(line[3]).parse,
    )
  end
end
