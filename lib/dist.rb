class UniDist
  def initialize min, max
    @min = min.to_f
    @max = max.to_f
  end
  def sample!
    rand * (@max - @min) + @min
  end
end

class ValDist
  def initialize x
    @x = x.to_f
  end
  def sample!
    @x
  end
end

class PhaseDist
  def initialize time, cost, cash, prob
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
  end
  def sample!
    Phase.new(
      @time.sample!,
      @cost.sample!,
      @cash.sample!,
      @prob.sample!,
    )
  end
end

class MarketDist
  def initialize time, cost, cash, prob
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
  end
  def sample!
    Market.new(@time.sample!, @cost.sample!, @cash.sample!, @prob.sample!)
  end
end

class ListDist
  def initialize list
    @list = list
  end
  def sample!
    @list.map(&:sample!)
  end
end

class PickDist
  def initialize list
    @list = list
  end
  def sample!
    @list.sample
  end
end

class DistParser
  def initialize data
    @data = data
  end
  def parse
    if @data.index '['
      ExprDist.new @data
    elsif @data.to_s.index '-'
      args = @data.split('-')
      UniDist.new args[0], args[1]
    else
      ValDist.new @data
    end
  end
end

class DoubleDist
  def initialize dist
    @dist = dist
  end
  def sample!
    @dist.sample!.sample!
  end
end

class ExprDist
  def initialize exp
    @exp = exp
  end
  def sample!
    if @exp.index('[')
      regex = /\[([\d-]*)\]/
      sample = DistParser.new(@exp[regex, 1]).parse.sample!
      ExprDist.new(@exp.sub(regex, sample.to_s)).sample!
    else
      eval @exp
    end
  end
end
