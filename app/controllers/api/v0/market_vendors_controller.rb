class Api::V0::MarketVendorsController < ApplicationController
  def create
    facade = MarketVendorFacade.new(market_vendor_params)
    response_message, response_status = facade.create

    render json: response_message, status: response_status
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end
