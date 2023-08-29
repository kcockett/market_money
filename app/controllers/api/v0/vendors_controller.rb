class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  def index
    market = Market.find(params[:market_id])
    facade = VendorsFacade.new(market)
    formatted_data = { data: facade.formatted_vendor_data }
    render json: formatted_data
  end

  def show
    vendor = Vendor.find(params[:id])
  end

  private
  
  def record_not_found
    render json: { "errors": [{"detail" => "Could not find Market with 'id'=#{params[:market_id]}"}] }, status: :not_found
  end
end