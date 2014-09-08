class ProvidersController < ApplicationController
  layout "provider_application"
  before_filter :require_employee_signin

  def dashboard
    current_provider
    @hubs = Provider.find(params[:provider_id]).hubs
    render "providers/dashboard/dashboard"
  end
end