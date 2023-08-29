class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: { errors: [{ detail: vendor.errors.full_messages.join(', ') }] }, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor), status: :ok
    else
      render json: { errors: [{ detail: vendor.errors.full_messages.join(', ') }] }, status: :bad_request
    end
  end  

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
  
  def record_not_found
    id = params[:market_id] || params[:id]
    render json: { "errors": [{"detail" => "Could not find Market with 'id'=#{id}"}] }, status: :not_found
  end
end