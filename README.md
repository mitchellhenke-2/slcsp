# SLCSP

Requirements:
 - Ruby 2.6.5

Usage:
 - To run the script using the provided data files, run `ruby run.rb slcsp.csv plans.csv zips.csv` and the script will output the CSV file on stdout with the rates filled in. Other CSV files can be used in their place if they have the same CSV structure. For more documentation see `run.rb`, `slcsp.rb`, `rate_area.rb`, and `zip_code.rb`

Testing:
 - Tests are written in `slcsp_test.rb` using Ruby's standard library Test::Unit framework.
 - The tests require the provided files `zips.csv` and `plans.csv` to exist in the same directory.
 - To run the tests, run `ruby slcsp_test.rb`
