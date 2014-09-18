class Admin::DashboardController < ApplicationController
  include PerspectiveSummary
  layout "admin_application"
  before_filter :require_admin_signin

  def main
    @sms = sms_balance_by_pump_table
    @total_credits_sold = credits_by_kiosk_for_all_table
    @total_water = dispensed_by_pump_for_all_table(true)
    @credits_remaining = credits_remaining_by_kiosk_table
    @credits_bought = credits_bought_by_kiosk(true)
    @viz_data = [credits_by_kiosk_by_month, credits_bought_by_kiosk,credits_remaining_by_kiosk, dispensed_by_pump_by_month, errors_by_hub_chart, getHubs]
    @new_hubs_hashes = Hub.get_new_hubs
  end
end
