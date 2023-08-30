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

    it "SAD PATH ex2.a If an invalid vendor id or and invalid market id is passed in, a 404 status code as well as a descriptive message should be sent back with the response.  " do
      vendor = create(:vendor)
      market = create(:market)
      # Pass invalid market_id
      params = { vendor_id: vendor.id, market_id: 987654321 }.to_json

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(creation_response[:errors][0][:detail]).to eq("Validation failed: Market must exist")

      vendor = create(:vendor)
      market = create(:market)
      # Pass invalid vendor_id
      params = { vendor_id: 987654321, market_id: market.id }.to_json

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(creation_response[:errors][0][:detail]).to eq("Validation failed: Vendor must exist")
    end

    it "SAD PATH ex2.b If a vendor id and/or a market id are not passed in, a 400 status code as well as a descriptive message should be sent back with the response." do
      vendor = create(:vendor)
      market = create(:market)
      # Do not send vendor_id
      params = { market_id: market.id }.to_json

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(creation_response[:errors][0][:detail]).to eq("Missing parameter: vendor_id")

      # Do not send market_id
      params = { vendor_id: vendor.id }.to_json

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(creation_response[:errors][0][:detail]).to eq("Missing parameter: market_id")
    end
  end
end