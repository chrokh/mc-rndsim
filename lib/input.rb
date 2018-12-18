require_relative 'agent'
require_relative 'market'
require_relative 'intervention'
require_relative 'phase'

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
