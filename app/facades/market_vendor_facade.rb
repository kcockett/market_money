class MarketVendorFacade
  def initialize(params)
    @params = params
  end

  def create
    if valid_params? # Verify both paramaters were sent in the request
      
      vendor = Vendor.find_by(id: @params[:vendor_id]) # Find the Vendor
      market = Market.find_by(id: @params[:market_id]) # Find the Market

      if vendor && market # Check if both were found
        market_vendor = MarketVendor.new(vendor: vendor, market: market) # If both found, create the object
        if market_vendor.save
          return { message: "Successfully added vendor to market" }, :created
        else
          return ErrorSerializer.serialize(market_vendor.errors), :bad_request
        end
      else
        set_error_messages(vendor, market)
        return ErrorSerializer.serialize(@errors.join(', ')), :not_found
      end
    else
      return ErrorSerializer.serialize("Missing parameter: #{@missing_params.join(', ')}"), :bad_request
    end
  end

  private

  def valid_params? 
    @missing_params = []
    @missing_params << "vendor_id" unless @params[:vendor_id].present?
    @missing_params << "market_id" unless @params[:market_id].present?
    @missing_params.empty?
  end

  def set_error_messages(vendor = nil, market = nil)
    @errors = ["Validation failed"]
    @errors << "Vendor must exist" unless vendor
    @errors << "Market must exist" unless market
    @status = :not_found
  end
end
