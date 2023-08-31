class MarketVendorFacade
  attr_reader :errors, :status

  def initialize(params)
    @params = params
    @errors = []
    @status = :bad_request
  end

  def create
    unless valid_params?
      set_error_messages
      return false
    end

    vendor = Vendor.find_by(id: @params[:vendor_id])
    market = Market.find_by(id: @params[:market_id])

    if vendor && market
      market_vendor = MarketVendor.new(vendor: vendor, market: market)
      if market_vendor.save
        @status = :created
        return true
      else
        @errors = market_vendor.errors
      end
    else
      set_error_messages(vendor, market)
    end

    false
  end

  def market_vendor_exists?
    MarketVendor.exists?(market_id: @params[:market_id], vendor_id: @params[:vendor_id])
  end

  def destroy
    vendor_id = @params[:vendor_id]
    market_id = @params[:market_id]

    market_vendor = MarketVendor.find_by(vendor_id: vendor_id, market_id: market_id)
    
    if market_vendor
      market_vendor.destroy
      return true
    else
      set_error_messages(["Association not found"], :not_found)
      return false
    end
  end

  private

  def valid_params?
    @params[:vendor_id].present? && @params[:market_id].present?
  end

  def set_error_messages(vendor = nil, market = nil)
    if !@params[:vendor_id].present? || !@params[:market_id].present?
      @errors = ["Missing parameter: vendor_id"] unless @params[:vendor_id].present?
      @errors = ["Missing parameter: market_id"] unless @params[:market_id].present?
      @status = :bad_request
    else
      @errors << "Vendor must exist" unless vendor
      @errors << "Market must exist" unless market
      @status = :not_found
    end
  end
end
