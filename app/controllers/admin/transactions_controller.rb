class Admin::TransactionsController < ApplicationController
  before_filter :require_admin_signin
  def create
    if params[:transactions]
      params[:transactions].each do |transaction_data|
        if hub = Hub.find_by(location_id:transaction_data[:location_id])
          hub.transactions.create(transaction_params(transaction_data))
        else
          Transaction.create(transaction_params(transaction_data))
        end
      end
    end
    render text: "Thanks for sending a POST request. Payload: #{request.body.read}"
  end

  private

  def transaction_params(transaction_data)
    transaction_data.permit(:rfid_id, :starting_credits, :ending_credits, :transaction_code, :amount, :error_code, :longitude, :latitude, :location_id, :provider_id, :transaction_time)
  end
end
