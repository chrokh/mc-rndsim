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
