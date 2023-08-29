class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  private
  
  def record_not_found
    render json: { "errors": [{"detail" => "Could not find Market with 'id'=#{params[:market_id]}"}] }, status: :not_found
  end
end