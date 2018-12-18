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

class CSVFormatter
  def initialize rows
    @rows = rows
  end
  def header
    @rows.first.keys.map { |k|
      if @rows.first[k].is_a? Array
        @rows.first[k].length.times.map { |n| "#{k}#{n}" }.join(',')
      else
        k
      end
    }.join(',')
  end
  def data
    @rows.map { |r| r.values.join(',') }.join("\r\n")
  end
end
