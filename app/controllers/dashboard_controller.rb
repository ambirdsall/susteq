class DashboardController < ApplicationController
  include PerspectiveSummary
  layout "provider_application"
  before_action :require_employee_signin

  def main
    @viz_data = [dispensed_by_pump_for_provider(current_provider), credits_sold_by_kiosk_for_provider(current_provider), getHubs]
    render "dashboard/main"
  end
end
