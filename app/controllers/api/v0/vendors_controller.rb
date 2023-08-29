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
      render_bad_request(vendor.errors)
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor), status: :ok
    else
      render_bad_request(vendor.errors)
    end
  end  

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
  
  def handle_record_not_found
    if action_name == 'index'
      market_not_found
    elsif action_name == 'show' || action_name == 'update'
      vendor_not_found
    end
  end

  def market_not_found
    render json: { "errors": [{"detail" => "Could not find Market with 'id'=#{params[:market_id]}" }] }, status: :not_found
  end

  def vendor_not_found
    render json: { "errors": [{"detail" => "Could not find Vendor with 'id'=#{params[:id]}" }] }, status: :not_found
  end

  def render_bad_request(errors)
    render json: { "errors": [{ "detail" => "Validation failed: #{errors.full_messages.join(', ')}" }] }, status: :bad_request
  end
end
