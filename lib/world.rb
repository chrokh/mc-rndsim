require_relative 'helpers'
require_relative 'decision_point'

class World
  def initialize id, group, phases, market, agent
    @id     = id
    @group  = group
    @phases = phases
    @market = market
    @agent  = agent
  end
  def decision_points
    @decision_points ||= Helpers.ladder(@phases).map do |phases|
      # TODO: Should e.g. pass agent rather than extract params and then pass
      DecisionPoint.new (phases + @market.phases), @agent.rate
    end
  end
  def run
    phases = @phases + @market.phases
    (
      {
        id:               @id,
        group:            @group,
      }
    ).merge(@agent.to_h).merge(
      {
        enpv:             decision_points.map(&:enpv),
        time:             phases.map(&:time),
        cost:             phases.map(&:cost),
        revenue:          phases.map(&:cash),
        prob:             phases.map(&:prob),
      }
    )
  end
  def apply effect
    n = effect.phase.to_i
    if n == @phases.length
      World.new(@id, effect.group, @phases, effect.apply(@market, Market), @agent)
    elsif n >= 0 && n < @phases.length
      phases = @phases.map.with_index do |e,i|
        if i == n then effect.apply(e, Phase) else e end
      end
      World.new(@id, effect.group, phases, @market, @agent)
    else
      raise "Attempting to apply intervention effect (#{effect.group}) to unknown phase (#{n})"
    end
  end
end
