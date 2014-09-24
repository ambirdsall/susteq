require 'faker'

def generate_date_from_last_six_months
  year = 2014
  month = rand(6)+4
  day = rand(30)+1     #Pour one out for n/31/2014; no pressing reason to add in the logic.
  DateTime.new(year, month, day)
end

FactoryGirl.define do
  factory :transaction do
    location_id {(0..9).to_a.sample}
    transaction_code {(1..200).to_a.sample}
    transaction_time {generate_date_from_last_six_months}
  end
end
