class Admin::KiosksController < ApplicationController
  include PerspectiveSummary
  layout "admin_application"
  before_action :require_admin_signin

  def new
    @kiosk = Kiosk.new
    @providers = Provider.all
  end

  def index
    @kiosks = Kiosk.all
    @viz_data = [credits_sold_by_kiosk_table(false), credits_sold_by_kiosk_by_month, getHubs]
  end

  def show
    @kiosk = Kiosk.find params[:id]
    @viz_data = [credits_sold_by_month(@kiosk)]
  end

  def create
    if params[:provider_id]
      begin
      @provider = Provider.find(params[:provider_id])
      @kiosk = Kiosk.create!(kiosk_params)
      redirect_to admin_provider_path(@provider)
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:error_messages] = invalid.record.errors.full_messages
        redirect_to new_admin_provider_kiosk_path(@provider)
      end
    else
      begin
      @kiosk = Kiosk.create!(kiosk_params)
      redirect_to admin_kiosks_path
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:error_messages] = invalid.record.errors.full_messages
        redirect_to new_admin_kiosk_path
      end
    end
  end

  def edit
    @kiosk = Kiosk.find params[:id]
  end

  def update
    kiosk = Kiosk.find(params[:id])
    if params[:provider_id]
      begin
      provider = Provider.find(params[:provider_id])
      kiosk.update!(kiosk_params)
      redirect_to admin_provider_path(provider)
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:error_messages] = invalid.record.errors.full_messages
        redirect_to edit_admin_provider_kiosk_path(provider,kiosk)
      end
    else
      begin
      kiosk.update!(kiosk_params)
      redirect_to admin_kiosks_path
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:error_messages] = invalid.record.errors.full_messages
        redirect_to edit_admin_kiosk_path(kiosk)
      end
    end
  end

  def destroy
    Kiosk.destroy(params[:id])
    if params[:provider_id]
      provider = Provider.find(params[:provider_id])
      redirect_to admin_provider_path(provider)
    else
      redirect_to admin_kiosks_path
    end
  end

  private
  def kiosk_params
    params.require(:kiosk).permit(:name,:longitude, :latitude, :location_id, :provider_id,:status_code)
  end
end
