class Admin::TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:create]

  def create
    if authorize_transaction
      if params[:transactions]
        params[:transactions].each do |transaction_data|
          transaction_data[:transaction_time] = Time.zone.at(transaction_data[:transaction_time])
          if hub = Hub.find_by(location_id:transaction_data[:location_id])
            hub.transactions.create(transaction_params(transaction_data))
          else
            Transaction.create(transaction_params(transaction_data))
          end
        end
      end
      render text: "Thanks for sending a POST request. Payload: #{request.body.read}"
    else
      render text: "Authorization failed!"
    end
  end

  private

  def transaction_params(transaction_data)
    transaction_data.permit(:rfid_id, :starting_credits, :ending_credits, :transaction_code, :amount, :error_code, :longitude, :latitude, :location_id, :provider_id, :transaction_time)
  end
end
