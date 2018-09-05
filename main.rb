class TriDist
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
  def initialize rate, mini, time, cost, cash, prob
    @rate = rate
    @mini = mini
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
  end
  def sample!
    Phase.new(
      @rate.sample!,
      @mini.sample!,
      @time.sample!,
      @cost.sample!,
      @cash.sample!,
      @prob.sample!
    )
  end
end

class Phase
  def initialize rate, mini, time, cost, cash, prob
    @rate = rate
    @mini = mini
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
  end
  def cashflow
    @cash - @cost
  end
end

class WorldDist
  def initialize phases
    @phases = phases
  end
  def sample!
    World.new @phases.map { |p| p.sample! }
  end
end

class World
  def initialize phases
    @phases = phases
  end
  def run
    puts "===="
    puts @phases
  end
end

def parse input
  WorldDist.new(
    File.readlines(input)
    .reject { |l| l=="\r\n" || l=="\r" || l=="\n" }
    .drop(1)
    .map { |l| parse_phase_dist l }
  )
end

def parse_dist dist
  if dist.index '-'
    args = dist.split('-')
    TriDist.new args[0], args[1]
  else
    ValDist.new dist
  end
end

def parse_phase_dist phase
  args = phase.gsub(' ', '').split ','
  PhaseDist.new(
    parse_dist(args[0]),
    parse_dist(args[1]),
    parse_dist(args[2]),
    parse_dist(args[3]),
    parse_dist(args[4]),
    parse_dist(args[5])
  )
end

def run n, input
  dist = parse input
  n.times do
    world = dist.sample!
    world.run
  end
end

run ARGV[0].to_i, ARGV[1]
