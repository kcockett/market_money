require "rails_helper"

RSpec.describe "MarketVendors API", type: :request do
  describe "8. POST /api/v0/market_vendors" do
    it "should create a new association between a market and a vendor.  When valid ids for vendor and market are passed in, a MarketVendor will be created, and a response will be sent back with a 201 status, detailing that a Vendor was added to a Market." do
      vendor = create(:vendor)
      vendor_data = vendor.to_json
      market = create(:market)
      market_data = market.to_json
      post "/api/v0/market_vendors", params: { vendor_id: vendor_data, market_id: market_data }, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      new_market_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response).to be_successful
      expect(new_market_vendor).to have_key(:id)
      expect(new_market_vendor[:id]).to be_a(String)

      expect(new_market_vendor[:attributes]).to have_key(:vendor_id)
      expect(new_market_vendor[:attributes][:vendor_id]).to eq("#{vendor.id}")

      expect(new_market_vendor[:attributes]).to have_key(:market_id)
      expect(new_market_vendor[:attributes][:market_id]).to eq("#{market.id}")

      expect(MarketVendor.first.vendor_id).to eq("#{vendor.id}")
      expect(MarketVendor.first.market_id).to eq("#{market.id}")
    end
  end
end