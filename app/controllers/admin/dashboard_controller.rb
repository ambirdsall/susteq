class Admin::DashboardController < ApplicationController
  include PerspectiveSummary
  layout "admin_application"
  before_filter :require_admin_signin

  def main
    @viz_data = [credits_sold_by_kiosk_by_month, credits_sold_by_kiosk_table(false),credits_remaining_by_kiosk_table(false), dispensed_by_pump_by_month, dispensed_by_pump_for_all_table(false), sms_balance_by_pump_table(false),errors_by_hub_table(false), getHubs]
    @new_hubs_hashes = Hub.get_new_hubs
  end
end
