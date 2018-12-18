require_relative 'effect'

class Intervention
  def initialize effects
    @effects = effects
  end
  def apply world
    @effects.reduce(world) { |w, i| w.apply i }
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

class InterventionsParser
  def initialize data
    @data = data
  end
  def parse
    lines = CSVParser.new(@data).lines
    keys  = lines.map(&:first).uniq
    ListDist.new(
      keys.map do |key|
        InterventionDist.new(
          lines
          .select { |l| l.first == key }
          .map { |e| EffectParser.new(e).parse }
        )
      end
    )
  end
end
