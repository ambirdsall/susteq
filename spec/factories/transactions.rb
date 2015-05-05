require 'faker'

def generate_date_from_last_six_months
  rand(6.months).seconds.ago
end

FactoryGirl.define do
  factory :transaction do
    location_id {(0..9).to_a.sample}
    transaction_code {(1..200).to_a.sample}
    transaction_time {generate_date_from_last_six_months}
  end
end
