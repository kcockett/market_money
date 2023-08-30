class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    if market_vendor.save
      render json: { message: "Successfully added vendor to market" }, status: :created
    else
      render json: ErrorSerializer.serialize(market_vendor.errors), status: :not_found
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end