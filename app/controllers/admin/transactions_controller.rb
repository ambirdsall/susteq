class Admin::TransactionsController < ApplicationController
  def create(transactions_json_array)
    transactions_json_array.each do |transaction_data|
      if hub = Hub.find_by(location_id:transaction_data.location_id)
        hub.transactions.create(transaction_data)
      else
        Transaction.create(transaction_data)
      end
    end
  end
end
