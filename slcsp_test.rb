require_relative './slcsp'
require 'test/unit'

class SLCSPTest < Test::Unit::TestCase
  def test_loads_plans_and_zip_codes
    slcsp = SLCSP.build_from_plan_and_zip_code_csvs('plans.csv', 'zips.csv')
    assert_equal slcsp.second_lowest_cost_silver_plan_by_zip_code('53202'),
                 324.3

    # no rate areas
    assert_equal slcsp.second_lowest_cost_silver_plan_by_zip_code('36006'),
                 nil

    # zip with multiple rate areas
    assert_equal slcsp.second_lowest_cost_silver_plan_by_zip_code('15829'),
                 nil

    # zip with one rate area with duplicate lowest rates
    assert_equal slcsp.second_lowest_cost_silver_plan_by_zip_code('16401'),
                 167.07
  end
end
