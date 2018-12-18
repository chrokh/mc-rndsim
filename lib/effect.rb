class Effect
  attr_reader :group, :operator, :operand, :phase, :property
  def initialize group, operator, operand, target_phase, property
    @group = group
    @operator = operator
    @operand = operand.to_f
    @phase = target_phase
    @property = property
  end
  def apply phase, klass
    case @property
    when 'time'
      x = phase.time.send(@operator, @operand)
      klass.new(x, phase.cost, phase.cash, phase.prob)
    when 'cost'
      x = phase.cost.send(@operator, @operand)
      x = x < 0 ? 0 : x
      klass.new(phase.time, x, phase.cash, phase.prob)
    when 'revenue'
      x = phase.cash.send(@operator, @operand)
      klass.new(phase.time, phase.cost, x, phase.prob)
    when 'prob'
      x = phase.prob.send(@operator, @operand)
      klass.new(phase.time, phase.cost, phase.cash, x)
    when 'risk'
      risk = (1 - phase.prob).send(@operator, @operand)
      klass.new(phase.time, phase.cost, phase.cash, (1-risk))
    else
      raise "Unknown property (#{@property}) in intervention effect."
    end
  end
end

class EffectParser
  def initialize data
    @data = data
  end
  def parse
    EffectDist.new(
      @data[0],
      @data[3],
      DistParser.new(@data[4]).parse,
      DistParser.new(@data[1]).parse,
      @data[2]
    )
  end
end

class EffectDist
  def initialize group, operator, operand, phase, property
    @group = group
    @operator = operator
    @operand = operand
    @phase = phase
    @property = property
  end
  def sample!
    Effect.new(
      @group,
      @operator,
      @operand.sample!,
      @phase.sample!.round,
      @property
    )
  end
end

