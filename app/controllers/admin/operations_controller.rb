class Admin::OperationsController < ApplicationController
	layout "admin_application"

	def index
		@transactions = Transaction.all
  	@total_amount_transactions_by_month = Transaction.select("extract(month from transaction_time) as name, sum(amount) as total" ).where("transaction_code = 20 or transaction_code = 21").group("name")
  end

end


# @total_amount_transactions_by_month = Transaction.all.
# 			where('extract(month from transaction_time) = ?', "05")