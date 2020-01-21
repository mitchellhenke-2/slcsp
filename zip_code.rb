require 'set'

# The ZipCode class has two attributes, the name of the zip code ('53207'),
# and a Set of rate area tuples ('WI1').
class ZipCode
  attr_reader :name, :rate_area_tuples

  def initialize(name)
    @name = name
    @rate_area_tuples = Set.new
  end

  def add_rate_area(rate_area)
    @rate_area_tuples.add(rate_area)
  end
end
