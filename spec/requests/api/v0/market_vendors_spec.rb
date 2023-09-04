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
      expect(creation_response[:errors][0][:detail]).to eq("Validation failed: Missing Vendor id")

      # Do not send market_id
      params = { vendor_id: vendor.id }.to_json

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(creation_response[:errors][0][:detail]).to eq("Validation failed: Missing Market id")
    end

    it "SAD PATH ex3 If there already exists a MarketVendor with that market_id and that vendor_id, a response with a 422 status code and a message informing the client that that association already exists, should be sent back. Looking at custom validation might help to implement a validation for uniqueness of the attributes for this resource." do
      vendor = create(:vendor)
      market = create(:market)
      params = { vendor_id: vendor.id, market_id: market.id }.to_json

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(creation_response[:message]).to eq("Successfully added vendor to market")

      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      duplicate_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(duplicate_response[:errors][0][:detail]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end

  describe "9. DELETE /api/v0/market_vendors" do
    it "should destroy an existing association between a market and a vendor (so that a vendor no longer is listed at a certain market).  When a MarketVendor resource can be found with the passed in vendor_id and market_id, that resource should be destroyed, and a response will be sent back with a 204 status, with nothing returned in the body of the request." do
      vendor = create(:vendor)
      market = create(:market)
      params = { vendor_id: vendor.id, market_id: market.id }.to_json
      post "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      creation_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(creation_response[:message]).to eq("Successfully added vendor to market")
      expect(MarketVendor.first.vendor_id).to eq(vendor.id)
      expect(MarketVendor.first.market_id).to eq(market.id)

      delete "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq("")
      expect(MarketVendor.first).to eq(nil)
    end

    it "SAD PATH If a MarketVendor resource can NOT be found with the passed in vendor_id and market_id, a 404 status code as well as a descriptive message should be sent back with the response." do
      vendor = create(:vendor)
      market = create(:market)
      params = { vendor_id: vendor.id, market_id: market.id }.to_json
      delete "/api/v0/market_vendors", params: params, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      deletion_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(deletion_response[:errors][0][:detail]).to eq("No record with market_id=#{market.id} AND vendor_id=#{vendor.id} exists")
    end
  end
end