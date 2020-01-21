require 'set'

# The RateArea class defines the data and logic for a health plan rate area.
# A rate area has a name that represents the state/rate area tuple ('WI1'), and
# a SortedSet of silver rate health plan costs (#<SortedSet: {198.0, 199.0}>).
#
# The silver_rates are stored as a SortedSet because determining the second
# lowest cost silver rate must have distinct rates. Example:
# A rate area with plans that cost [199.0, 199.0, 199.0] would not have
# a second lowest cost silver plan.
class RateArea
  attr_reader :name, :silver_rates

  def initialize(name)
    @name = name
    @silver_rates = SortedSet.new
  end

  def add_silver_rate(rate)
    silver_rates.add(rate)
  end

  # Returns the second lowest cost silver plan for the RateArea.
  # If there are 0 or 1 silver plan costs, the second lowest cost silver plan
  # cannot be deterimend.
  #
  # Returns nil if the SLCSP cannot be determined
  def second_lowest_cost_silver_plan
    return if silver_rates.length < 2

    silver_rates.to_a[1]
  end
end
