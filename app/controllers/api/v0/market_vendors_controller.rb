class Api::V0::MarketVendorsController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    vendor = Vendor.find_by(id: market_vendor_params[:vendor_id])
    market = Market.find_by(id: market_vendor_params[:market_id])

    unless market_vendor_params[:vendor_id].present? && market_vendor_params[:market_id].present?
      error_message = []
      error_message << "Missing parameter: vendor_id" unless market_vendor_params[:vendor_id].present?
      error_message << "Missing parameter: market_id" unless market_vendor_params[:market_id].present?
      render_error('MarketVendor', error_message.join(', '), :bad_request)
      return
    end
  
    if vendor && market
      market_vendor = MarketVendor.new(vendor: vendor, market: market)
      if market_vendor.save
        render json: { message: "Successfully added vendor to market" }, status: :created
      else
        render_error(market_vendor.errors, :bad_request)
      end
    else
      error_message = []
      error_message << "Vendor must exist" unless vendor
      error_message << "Market must exist" unless market
      render_error('MarketVendor', error_message, :not_found)
    end
  end
  

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end


  def render_error(entity, errors, status)
    render json: ErrorSerializer.serialize(errors), status: status
  end
end