class Cashflow
  def initialize cashflow, time_to, initial_prob, remaining_prob
    @cashflow = cashflow
    @time_to = time_to
    @initial_prob = initial_prob
    @remaining_prob = remaining_prob
  end
  def pv rate
    @cashflow / ((1 + rate) ** @time_to)
  end
  def epv rate
    pv(rate) * (@initial_prob / @remaining_prob)
  end
end
