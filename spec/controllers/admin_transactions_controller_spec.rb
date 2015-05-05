require 'rails_helper'

def generate_date_from_last_six_months
  rand(6.months).seconds.ago
end

describe Admin::TransactionsController do

  describe 'POST transactions#create' do
    before do
      @admin = Admin.create!(
      name: "susteq",
      email: "susteq@dbc.com",
      password: "123456")
    end

    after do
      admin = @admin.destroy
    end
    existing_transaction_time = generate_date_from_last_six_months

    let(:params) {{format: :json,

                  email:"susteq@dbc.com",
                  password:"123456",

                  transactions: [
                    {transaction_time:existing_transaction_time,
                    transaction_code: 20,
                    location_id: 1,
                    amount: 2 },

                    {transaction_time:generate_date_from_last_six_months,
                    transaction_code: 20,
                    location_id: 1,
                    amount:2},

                    {transaction_time:existing_transaction_time,
                    transaction_code: 20,
                    location_id: 1,
                    amount:2}
                  ]
                }}
    let(:bad_params) {{format: :json,

                  email:"susteq@dbc.com",
                  password:"12345678",

                  transactions: [
                    {transaction_time:generate_date_from_last_six_months,
                    transaction_code: 20,
                    location_id: 1,
                    amount: 2 },

                    {transaction_time:generate_date_from_last_six_months,
                    transaction_code: 20,
                    location_id: 1,
                    amount:2}
                  ]
                }}

    let(:headers) {{ 'CONTENT_TYPE' => 'application/json' }}
    it 'returns a successful status' do
      post :create
      assert_response :success
    end

    it 'return a successful message when authorized' do
      post :create, params, headers
      expect(response.body).to include("Thanks for sending a POST request")
    end

    it 'returns a failure message when unauthorized' do
      post :create, bad_params, headers
      expect(response.body).to eq("Authorization failed!")
    end

    it 'creates new transactions when authorized' do
      expect{
        post :create, params, headers
      }.to change(Transaction, :count)
    end

    it 'does not create new transactions when unauthorized' do
      expect{
        post :create, bad_params, headers
      }.to_not change(Transaction, :count)
    end

    it 'associates new transactions with existing hubs (by location id)' do
      kiosk = Kiosk.create(location_id:1)
      expect{
        post :create, params, headers
      }.to change(kiosk.transactions, :count)
    end

    it "will only new transactions and not duplicate existing transactions" do
      kiosk = Kiosk.create(location_id:1)
      expect{
        post :create, params, headers
      }.to change(kiosk.transactions, :count).by(2)
    end
  end
end
