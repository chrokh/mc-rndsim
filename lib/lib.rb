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
      @prob.sample!
    )
  end
end

class Phase
  attr_reader :time, :cost, :cash, :prob
  def initialize time, cost, cash, prob
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
  end
  def apply intervention
    operator = intervention.operator
    operand  = intervention.operand
    property = intervention.property
    case property
    when 'revenue'
      Phase.new(@time, @cost, @cash.send(operator, operand), @prob)
    when 'cost'
      cost = @cost.send(operator, operand)
      cost = cost < 0 ? 0 : cost
      Phase.new(@time, cost, @cash, @prob)
    else
      raise Error, 'Invalid intervention'
    end
  end
end

class Market
  attr_reader :time, :cost, :cash, :prob
  def initialize time, cost, cash, prob
    @time = time
    @cost = cost
    @cash = cash
    @prob = prob
  end
  def phases
    x = @time.to_i.times.map do |t|

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

class World
  def initialize phases, market, rate, mini
    @phases = phases
    @market = market
    @rate = rate
    @mini = mini
  end
  def decision_points
    @decision_points ||= ladder(@phases).map do |phases|
      DecisionPoint.new (phases + @market.phases), @rate, @mini
    end
  end
  def run name
    enpvs   = decision_points.map(&:enpv)
    gonos   = decision_points.map(&:decision)
    conseqs = gonos.reduce([true]) { |acc, x| acc << (acc.last && x) }.drop(1)
    phases  = @phases + @market.phases
    {
      enpv:             enpvs,
      decision:         gonos,
      conseq_decision:  conseqs,
      time:             phases.map(&:time),
      cost:             phases.map(&:cost),
      revenue:          phases.map(&:cash),
      prob:             phases.map(&:prob),
    }.map { |k,v| ["#{name}#{k}", v] }.to_h
  end
  def apply intervention
    phases = @phases.map.with_index do |e,i|
      if i == intervention.phase.to_i
        e.apply intervention
      else
        e
      end
    end
    World.new(phases, @market, @rate, @mini)
  end
end

class SimulationDist
  def initialize config
    @config = config
  end
  def sample!
    Simulation.new(
      @config.phases.map { |p| p.sample! },
      @config.market.sample!,
      @config.rate.sample!,
      @config.mini.sample!,
      @config.interventions.sample!
    )
  end
end

class Simulation
  def initialize phases, market, rate, mini, interventions
    @phases = phases
    @market = market
    @rate = rate
    @mini = mini
    @interventions = interventions
  end
  def run
    baseline = World.new(@phases, @market, @rate, @mini)
    deviations = @interventions.keys.map { |key|
      intervention = @interventions[key]
      deviation = intervention.apply(baseline)
      Hash[
        "#{key}intervention_phase"    => intervention.phase,
        "#{key}intervention_operator" => intervention.operator,
        "#{key}intervention_operand"  => intervention.operand,
        "#{key}intervention_property" => intervention.property,
      ].merge(deviation.run(key))
    }.reduce(&:merge) || {}
    {
      discount_rate:         @rate,
      threshold:             @mini,
    }.merge(baseline.run('')).merge(deviations)
  end
end

class DecisionPoint
  def initialize phases, rate, mini
    @phases = phases
    @rate   = rate
    @mini   = mini # TODO: Should not be passed through constructor?
  end
  def remaining_prob
    @phases.map(&:prob).reduce(&:*)
  end
  def enpv
    @enpv ||= epvs.reduce(&:+)
  end
  def epvs
    cashflows.map { |c| c.epv @rate }
  end
  def cashflows
    ladder(@phases.reverse).map do |flows|
      time_to                  = flows.drop(1).map(&:time).reduce(0, &:+)
      completed_prob_at_flow   = flows.drop(1).map(&:prob).reduce(1, &:*)
      remaining_prob_from_flow = remaining_prob / completed_prob_at_flow
      cashflow                 = flows.first.cash - flows.first.cost
      Cashflow.new(cashflow, time_to, remaining_prob, remaining_prob_from_flow)
    end
  end
  def decision
    enpv >= @mini
  end
end

class Cashflow
  def initialize cashflow, time_to, initial_prob, remaining_prob
    @cashflow = cashflow
    @time_to = time_to
    @initial_prob = initial_prob
    @remaining_prob = remaining_prob
  end
  def pv rate
    @cashflow / ((1 + rate) ** @time_to)
  end
  def epv rate
    pv(rate) * (@initial_prob / @remaining_prob)
  end
end

def ladder xs
  xs.reduce([]) { |xs, x| (xs.map{|y| y<<x}) << [x] }
end

class MarketParser
  def initialize data
    @data = data
  end
  def parse
    line = CSVParser.new(@data).lines.last
    MarketDist.new(
      parse_dist(line[0]),
      parse_dist(line[1]),
      parse_dist(line[2]),
      parse_dist(line[3]),
    )
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
        parse_dist(line[0]),
        parse_dist(line[1]),
        parse_dist(line[2]),
        parse_dist(line[3]),
      )
    end
  end
end

class CSVParser
  def initialize data
    @data = data
  end
  def lines
    @data
      .split("\n")
      .drop(1)
      .map { |line| line.split(',') }
      .map { |line| line.map { |value| value.strip } }
  end
end

class InterventionsParser
  def initialize data
    @data = data
  end
  def parse
    interventions = CSVParser.new(@data).lines.map do |line|
      Hash[
        line[0],
        InterventionDist.new(
          line[3],
          parse_dist(line[4]),
          parse_dist(line[1]),
          line[2]
        )]
    end.reduce(&:merge)
    MultiDist.new(interventions)
  end
end

class MultiDist
  def initialize hash
    @hash = Hash(hash)
  end
  def sample!
    @hash.keys.map do |key|
      Hash[key, @hash[key].sample!]
    end.reduce(&:merge) || {}
  end
end

class InterventionDist
  def initialize operator, operand, phase, property
    @operator = operator
    @operand = operand
    @phase = phase
    @property = property
  end
  def sample!
    Intervention.new(
      @operator,
      @operand.sample!,
      @phase.sample!.round,
      @property
    )
  end
end

class Intervention
  attr_reader :operator, :operand, :phase, :property
  def initialize operator, operand, phase, property
    @operator = operator
    @operand = operand
    @phase = phase
    @property = property
  end
  def apply world
    world.apply self
  end
end

def parse_dist dist
  if dist.to_s.index '-'
    args = dist.split('-')
    UniDist.new args[0], args[1]
  else
    ValDist.new dist
  end
end

class Writer
  def initialize output
    @output = output
    @cache  = []
    @has_written_header = false
  end
  def append data
    @cache << data
  end
  def flush!
    @cache.each do |data|
      csv = CSVFormatter.new data
      if @has_written_header
        open(@output, 'a') { |f| f.puts csv.data }
      else
        open(@output, 'w') { |f| f.puts csv.header }
        @has_written_header = true
      end
    end
    @cache = []
  end
end

class CSVFormatter
  def initialize data
    @data = data
  end
  def header
    @data.keys.map { |k|
      if @data[k].is_a? Array
        @data[k].length.times.map { |n| "#{k}#{n}" }.join(',')
      else
        k
      end
    }.join(',')
  end
  def data
    @data.values.map do |v|
      if v.is_a? Array
        v.join(',')
      else
        v
      end
    end.join(',')
  end
end

class InputParser
  def initialize config, phases, interventions
    @config = config
    @phases = phases
    @interventions = interventions
  end
  def mini
    parse_dist @config['threshold']
  end
  def rate
    parse_dist @config['discount_rate']
  end
  def market
    MarketParser.new(@phases).parse
  end
  def interventions
    InterventionsParser.new(@interventions).parse
  end
  def phases
    PhasesParser.new(@phases).parse
  end
end

require 'yaml'
class SimulationParser
  def initialize config, phases, interventions
    @config = config
    @phases = phases
    @interventions = interventions
  end
  def parse
    SimulationDist.new(
      InputParser.new(
        YAML.load_file(@config),
        File.read(@phases),
        File.read(@interventions),
      ))
  end
end

