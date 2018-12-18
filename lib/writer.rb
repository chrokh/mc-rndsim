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
