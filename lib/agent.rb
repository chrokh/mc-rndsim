class Agent
  attr_reader :rate
  def initialize name, rate
    @name = name
    @rate = rate
  end
  def to_h
    {
      agent:         @name,
      discount_rate: @rate,
    }
  end
end

class AgentDist
  def initialize name, rate
    @name = name
    @rate = rate
  end
  def sample!
    Agent.new(
      @name,
      @rate.sample!,
    )
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
            DistParser.new(line[1]).parse
          )
        end
      )
    )
  end
end
