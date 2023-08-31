class Api::V0::MarketVendorsController < ApplicationController
  def create
    facade = MarketVendorFacade.new(market_vendor_params)

    if facade.market_vendor_exists?
      render_error(["Association already exists"], :unprocessable_entity)
    elsif facade.create
      render json: { message: "Successfully added vendor to market" }, status: facade.status
    else
      render_error(facade.errors, facade.status)
    end
  end

  def destroy
    facade = MarketVendorFacade.new(market_vendor_params)

    if facade.destroy
      head :no_content
    else
      render_error(facade.errors, facade.status)
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  def render_error(errors, status)
    render json: ErrorSerializer.serialize(errors), status: status
  end
end
