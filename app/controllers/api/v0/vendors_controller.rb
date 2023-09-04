class Api::V0::VendorsController < ApplicationController
  def index
    begin
      market = Market.find(market_params[:market_id])
    rescue
      render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{market_params[:market_id]}"), status: :not_found
    end
    if market
      render json: VendorSerializer.new(market.vendors)
    end
  end
  
  def show
    begin
      vendor = Vendor.find(params[:id])
      render json: VendorSerializer.new(vendor)
    rescue
      render json: ErrorSerializer.serialize("Couldn't find Vendor with 'id'=#{params[:id]}"), status: :not_found
    end
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
    begin
      vendor = Vendor.find(params[:id])
    rescue
      render json: ErrorSerializer.serialize("Couldn't find Vendor with 'id'=#{params[:id]}"), status: :not_found
    end

    if vendor
      if vendor.update(vendor_params)
        render json: VendorSerializer.new(vendor), status: :ok
      else
        render json: ErrorSerializer.serialize(vendor.errors), status: :bad_request
      end
    end
  end

  def destroy
    begin
      vendor = Vendor.find(params[:id])
      vendor.market_vendors.destroy_all
      vendor.destroy
      head :no_content
    rescue
      render json: ErrorSerializer.serialize("Couldn't find Vendor with 'id'=#{params[:id]}"), status: :not_found
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:id, :name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def market_params
    params.permit(:market_id)
  end
end
