require 'rails_helper'

def generate_date_from_last_six_months
  year = 2014
  month = rand(6)+4
  day = rand(30)+1
  DateTime.new(year, month, day)
end

describe Admin::TransactionsController do

  describe 'POST transactions#create' do
    let(:params) {{format: :json, transactions: [
                {transaction_time:generate_date_from_last_six_months,
                transaction_code: 20,
                location_id: 1,
                amount: 2 },

                {transaction_time:generate_date_from_last_six_months,
                transaction_code: 20,
                location_id: 1,
                amount:2}]
                }}
      let(:headers) {{ 'CONTENT_TYPE' => 'application/json' }}
    it 'returns a successful status' do
      post :create
      assert_response :success
    end

    it 'creates new transactions' do
      expect{
        post :create, params, headers
      }.to change(Transaction, :count)
    end

    it 'associates new transactions with existing hubs (by location id)' do
      kiosk = Kiosk.create(location_id:1)
      expect{
        post :create, params, headers
      }.to change(kiosk.transactions, :count)
    end
  end
end