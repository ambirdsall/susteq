require_relative '../rails_helper'

describe Transaction do
  describe "checks for uniqueness of transactions" do
    subject {build(:transaction)}
    it {should validate_uniqueness_of(:transaction_code).scoped_to([:location_id, :transaction_time])}
  end
end