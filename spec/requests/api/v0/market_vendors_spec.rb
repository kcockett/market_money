require "rails_helper"

RSpec.describe "MarketVendors API", type: :request do
  describe "8. POST /api/v0/market_vendors" do
    it "should create a new association between a market and a vendor.  When valid ids for vendor and market are passed in, a MarketVendor will be created, and a response will be sent back with a 201 status, detailing that a Vendor was added to a Market." do
      vendor = create(:vendor)
      market = create(:market)
      params = { vendor_id: vendor.id, market_id: market.id }.to_json

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(creation_response[:message]).to eq("Successfully added vendor to market")

      get "/api/v0/markets/#{market.id}/vendors"
      verify_response = JSON.parse(response.body, symbolize_names: true)[:data]
      new_vendor = verify_response[0]

      expect(new_vendor[:id]).to eq("#{vendor.id}")
    end
  end
end