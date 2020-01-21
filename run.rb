require 'csv'
require_relative './slcsp'

# Expects to be called with three arguments from the commmand line.
# The arguments being:
# 1. The source CSV that lists the zip codes to calculate the SLCSP for.
#      The file should have the columns and header:
#      zipcode, rate
# 2. The plan CSV that lists the plans, File should have columns and header:
#      plan_id, state, metal_level, rate, rate_area
# 3. The zip CSV that lists the zip codes. File should have columns and header:
#      zipcode, state, county_code, name, rate_area
#
# The program will emit the resulting CSV on stdout with the rate column filled in.
# If the rate cannot be determined for a zip code, the rate column will be
# blank.
#
# Example to write a filled in csv to file named slcsp_filled.csv:
# ruby run.rb slcsp.csv plans.csv zips.csv > slcsp_filled.csv

source_csv = ARGV.shift
plan_csv = ARGV.shift
zip_csv = ARGV.shift

slcsp = SLCSP.build_from_plan_and_zip_code_csvs(plan_csv, zip_csv)

csv_string = CSV.generate do |new_csv|
  new_csv << ['zipcode', 'rate']

  CSV.read(source_csv, headers: true).each do |row|
    zip = row['zipcode']

    rate = slcsp.second_lowest_cost_silver_plan_by_zip_code(zip)

    if rate
      new_csv << [zip, sprintf('%.2f', rate)]
    else
      new_csv << [zip, nil]
    end
  end
end

puts csv_string
