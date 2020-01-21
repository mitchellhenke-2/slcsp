require_relative './zip_code'
require_relative './rate_area'
require 'csv'

# The SLCSP class holds the logic and data for determining the
# second lowest cost silver plan (SLCSP) by zip code.
#
# The class has two attribute. The zip_code_dictionary maps
# a zip code ('53207') to a ZipCode object. The rate_area_dictionary maps
# a rate area tuple ('WI1') to a RateArea object.
class SLCSP
  attr_reader :zip_code_dictionary, :rate_area_dictionary
  def initialize
    @zip_code_dictionary = {}
    @rate_area_dictionary = {}
  end

  # The second lowest cost silver plan cannot be determined for a zip code
  # if it has no rate areas, or if it belongs to more than one rate area.
  #
  # Returns a float for the rate of the second cost lowest plan or nil if the
  # second lowest cost silver plan cannot be determined.
  def second_lowest_cost_silver_plan_by_zip_code(zip_code)
    zip_code = @zip_code_dictionary[zip_code]

    return nil unless zip_code
    return nil if zip_code.rate_area_tuples.length != 1

    rate_area_tuple = zip_code.rate_area_tuples.first

    rate_area = @rate_area_dictionary[rate_area_tuple]
    return nil unless rate_area

    rate_area.second_lowest_cost_silver_plan
  end

  # Builds SLCSP object from plan CSV and zip code CSV
  # The plan CSV should have header row and values with:
  # plan_id, state, metal_level, rate, rate_area
  #
  # The zip code CSV should have header row and values with:
  # zipcode, state, county_code, name, rate_area
  #
  # Returns SLCSP object
  def self.build_from_plan_and_zip_code_csvs(plan_path, zip_code_path)
    slcsp = SLCSP.new

    plans = CSV.read(plan_path, headers: true)
    plans.each do |plan|
      state = plan['state']
      rate_area = plan['rate_area']
      state_rate_area = "#{state}#{rate_area}"
      rate = plan['rate'].to_f

      next unless plan['metal_level'] == 'Silver'

      slcsp.rate_area_dictionary[state_rate_area] ||= RateArea.new(state_rate_area)
      rate_area = slcsp.rate_area_dictionary[state_rate_area]
      rate_area.add_silver_rate(rate)
    end

    zips = CSV.read(zip_code_path, headers: true)
    zips.each do |zip|
      zip_code = zip['zipcode']
      rate_area = "#{zip['state']}#{zip['rate_area']}"

      slcsp.zip_code_dictionary[zip_code] ||= ZipCode.new(zip_code)

      zip_code = slcsp.zip_code_dictionary[zip_code]

      zip_code.add_rate_area(rate_area)
    end

    slcsp
  end
end
