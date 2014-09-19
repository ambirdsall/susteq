class Admin::OperationsController < ApplicationController
	layout "admin_application"

	def index
    @sms = sms_balance_by_pump_table
    @total_credits_sold = credits_sold_by_kiosk_table(true)
    @total_water = dispensed_by_pump_for_all_table(true)
    @credits_remaining = credits_remaining_by_kiosk_table(true)
    @credits_bought = credits_bought_by_kiosk_table(true)
    @error_hashes = errors_by_hub_table(true)
  end
end
