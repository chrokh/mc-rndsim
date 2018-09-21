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
  def initialize phases, market, agent
    @phases = phases
    @market = market
    @agent  = agent
  end
  def decision_points
    @decision_points ||= ladder(@phases).map do |phases|
      # TODO: Should e.g. pass agent rather than extract params and then pass
      DecisionPoint.new (phases + @market.phases), @agent.rate, @agent.mini
    end
  end
  def run name
    enpvs   = decision_points.map(&:enpv)
    gonos   = decision_points.map(&:decision)
    conseqs = gonos.reduce([true]) { |acc, x| acc << (acc.last && x) }.drop(1)
    phases  = @phases + @market.phases
    @agent.to_h.merge(
      {
        enpv:             enpvs,
        decision:         gonos,
        conseq_decision:  conseqs,
        time:             phases.map(&:time),
        cost:             phases.map(&:cost),
        revenue:          phases.map(&:cash),
        prob:             phases.map(&:prob),
      }.map { |k,v| ["#{name}#{k}", v] }.to_h
    )
  end
  def apply effect
    phases = @phases.map.with_index do |e,i|
      if i == effect.phase.to_i
        effect.apply e
      else
        e
      end
    end
    World.new(phases, @market, @agent)
  end
end

class SimulationDist
  def initialize parser
    @parser = parser
  end
  def sample!
    Simulation.new(
      @parser.phases.map { |p| p.sample! },
      @parser.market.sample!,
      @parser.agents.sample!,
      @parser.interventions.sample!
    )
  end
end

class Simulation
  def initialize phases, market, agent, interventions
    @phases = phases
    @market = market
    @agent  = agent
    @interventions = interventions
  end
  def run
    baseline = World.new(@phases, @market, @agent)
    deviations =
      @interventions.keys.map { |key| @interventions[key].apply(baseline).run(key) }
      .reduce(&:merge) || {}

    baseline.run('').merge(deviations)
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
      DistParser.new(line[0]).parse,
      DistParser.new(line[1]).parse,
      DistParser.new(line[2]).parse,
      DistParser.new(line[3]).parse,
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
        DistParser.new(line[0]).parse,
        DistParser.new(line[1]).parse,
        DistParser.new(line[2]).parse,
        DistParser.new(line[3]).parse,
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

class EffectParser
  def initialize data
    @data = data
  end
  def parse
    EffectDist.new(
      @data[3],
      DistParser.new(@data[4]).parse,
      DistParser.new(@data[1]).parse,
      @data[2]
    )
  end
end

class InterventionsParser
  def initialize data
    @data = data
  end
  def parse
    lines = CSVParser.new(@data).lines
    interventions = lines.map(&:first).map do |id|
      effects = lines
        .select { |l| l[0] == id }
        .map { |e| EffectParser.new(e).parse }
      intervention = InterventionDist.new(effects)
      Hash[id, intervention]
    end.reduce(&:merge)
    HashDist.new(interventions)
  end
end

class HashDist
  def initialize hash
    @hash = Hash(hash)
  end
  def sample!
    @hash.keys.map do |key|
      Hash[key, @hash[key].sample!]
    end.reduce(&:merge) || {}
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

class InterventionDist
  def initialize effects
    @effects = effects
  end
  def sample!
    Intervention.new(@effects.map(&:sample!))
  end
end

class EffectDist
  def initialize operator, operand, phase, property
    @operator = operator
    @operand = operand
    @phase = phase
    @property = property
  end
  def sample!
    Effect.new(
      @operator,
      @operand.sample!,
      @phase.sample!.round,
      @property
    )
  end
end

class Intervention
  def initialize effects
    @effects = effects
  end
  def apply world
    @effects.reduce(world) { |w, i| w.apply i }
  end
end

class AgentDist
  def initialize name, rate, mini
    @name = name
    @rate = rate
    @mini = mini
  end
  def sample!
    Agent.new(
      @name,
      @rate.sample!,
      @mini.sample!
    )
  end
end

class Agent
  attr_reader :rate, :mini
  def initialize name, rate, mini
    @name = name
    @rate = rate
    @mini = mini
  end
  def to_h
    {
      agent:         @name,
      discount_rate: @rate,
      threshold:     @mini
    }
  end
end

class Effect
  attr_reader :operator, :operand, :phase, :property
  def initialize operator, operand, target_phase, property
    @operator = operator
    @operand = operand.to_f
    @phase = target_phase
    @property = property
  end
  def apply phase
    case @property
    when 'revenue'
      Phase.new(phase.time, phase.cost, phase.cash.send(@operator, @operand), phase.prob)
    when 'cost'
      cost = phase.cost.send(@operator, @operand)
      cost = cost < 0 ? 0 : cost
      Phase.new(phase.time, cost, phase.cash, phase.prob)
    else
      raise Error, 'Invalid intervention effect'
    end
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

class DistParser
  def initialize data
    @data = data
  end
  def parse
    if @data.to_s.index '-'
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

class AgentsParser
  def initialize data
    @data = data
  end
  def parse
    DoubleDist.new(
      PickDist.new(
        CSVParser.new(@data).lines.map do |line|
          AgentDist.new(
            line[0],
            DistParser.new(line[1]).parse,
            DistParser.new(line[2]).parse
          )
        end
      )
    )
  end
end

class InputParser
  def initialize agents, phases, interventions
    @agents = agents
    @phases = phases
    @interventions = interventions
  end
  def agents
    AgentsParser.new(@agents).parse
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
  def initialize agents, phases, interventions
    @agents = agents
    @phases = phases
    @interventions = interventions
  end
  def parse
    SimulationDist.new(
      InputParser.new(
        File.read(@agents),
        File.read(@phases),
        File.read(@interventions),
      ))
  end
end

