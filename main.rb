require_relative 'lib/lib'

def run n, input1, input2, input3, output, seed
  unless seed.nil? then srand(seed.to_i) end
  writer = Writer.new output
  dist   = SimulationParser.new(input1, input2, input3).parse
  n.times do |i|
    writer.append (dist.sample!.run(i))
    if (i > 0 && i % 100 == 0) || (i+1) == n
      system "clear" or system "cls"
      puts "#{((i+1) / n.to_f * 100).round} %"
      writer.flush!
    end
  end
  writer.flush!
end

run(ARGV[0].to_i, ARGV[1], ARGV[2], ARGV[3], ARGV[4], ARGV[5])
