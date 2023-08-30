class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

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
      render json: ErrorSerializer.serialize(vendor.errors), status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor), status: :ok
    else
      render json: ErrorSerializer.serialize(vendor.errors), status: :bad_request
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.market_vendors.destroy_all
    vendor.destroy
    head :no_content
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
  
  def handle_record_not_found
    if action_name == 'index'
      render json: ErrorSerializer.not_found('Market', params[:market_id]), status: :not_found
    elsif action_name == 'show' || action_name == 'update'
      render json: ErrorSerializer.not_found('Vendor', params[:id]), status: :not_found
    end
  end
end
