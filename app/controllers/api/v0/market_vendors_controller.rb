class Api::V0::MarketVendorsController < ApplicationController
  def create
    if market_vendor_params[:market_id] == nil
      render json: ErrorSerializer.serialize("Validation failed: Missing Market id"), status: :bad_request
    elsif market_vendor_params[:vendor_id] == nil
      render json: ErrorSerializer.serialize("Validation failed: Missing Vendor id"), status: :bad_request
    elsif MarketVendor.exists?(market_id: market_vendor_params[:market_id], vendor_id: market_vendor_params[:vendor_id])
      render json: ErrorSerializer.serialize("Validation failed: Market vendor asociation between market with market_id=#{market_vendor_params[:market_id]} and vendor_id=#{market_vendor_params[:vendor_id]} already exists"), status: :unprocessable_entity
    elsif !Market.exists?(market_vendor_params[:market_id])
      render json: ErrorSerializer.serialize("Validation failed: Market must exist"), status: :not_found
    elsif !Vendor.exists?(market_vendor_params[:vendor_id])
      render json: ErrorSerializer.serialize("Validation failed: Vendor must exist"), status: :not_found
    else
      MarketVendor.create!(market_id: market_vendor_params[:market_id], vendor_id: market_vendor_params[:vendor_id])
      render json: { message: "Successfully added vendor to market" }, status: :created
    end
  end

  def destroy
    facade = MarketVendorFacade.new(market_vendor_params)
  
    if facade.destroy
      head :no_content
    else
      render json: ErrorSerializer.serialize(facade.errors), status: :not_found
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end
