require_relative 'helpers'
require_relative 'cashflow'

class DecisionPoint
  def initialize phases, rate
    @phases = phases
    @rate   = rate
  end
  def remaining_prob
    @phases.map(&:prob).reduce(&:*)
  end
  def enpv
    @enpv ||= epvs.reduce(&:+)
  end
  def epvs
    cashflows.map { |c| c.epv @rate }
  end
  def cashflows
    Helpers.ladder(@phases.reverse).map do |flows|
      time_to                  = flows.drop(1).map(&:time).reduce(0, &:+)
      completed_prob_at_flow   = flows.drop(1).map(&:prob).reduce(1, &:*)
      remaining_prob_from_flow = remaining_prob / completed_prob_at_flow
      cashflow                 = flows.first.cash - flows.first.cost
      Cashflow.new(cashflow, time_to, remaining_prob, remaining_prob_from_flow)
    end
  end
end
