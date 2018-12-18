require_relative 'input'
require_relative 'world'

class Simulation
  def initialize phases, market, agent, interventions
    @phases = phases
    @market = market
    @agent  = agent
    @interventions = interventions
  end
  def run id
    baseline   = World.new(id, 'base', @phases, @market, @agent)
    deviations = @interventions.map { |i| i.apply(baseline) }
    [baseline.run] + deviations.map(&:run)
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

