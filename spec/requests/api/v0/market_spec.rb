require "rails_helper"

RSpec.describe "Markets", type: :request do
  describe "1. GET /api/v0/markets" do
    it "should return a list of all markets in the database" do
      market_list = create_list(:market,4)
      get "/api/v0/markets"
      response_data = JSON.parse(response.body, symbolize_names: true)
      markets = response_data[:data]
      
      expect(response).to be_successful
      expect(markets.size).to eq(4)
      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)

        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a(String)

        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a(String)

        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a(String)

        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a(String)

        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_a(String)

        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_a(String)

        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_a(String)

        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_a(String)

        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_an(Integer)
        expect(market[:attributes][:vendor_count]).to eq(0)
      end
    end
  end

  describe "2. GET /api/v0/markets/:id" do
    it "should return a single market by id" do
      market = create(:market)
      vendors = create_list(:vendor,4)
      vendors.each do |vendor|
        MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)
      end
      get "/api/v0/markets/#{market.id}"
      response_data = JSON.parse(response.body, symbolize_names: true)
      market_found = response_data[:data]

      expect(response).to be_successful
      expect(market_found[:attributes][:vendor_count]).to eq(4)
      expect(market_found).to have_key(:id)
      expect(market_found[:id]).to be_an(String)

      expect(market_found[:attributes]).to have_key(:name)
      expect(market_found[:attributes][:name]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:street)
      expect(market_found[:attributes][:street]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:city)
      expect(market_found[:attributes][:city]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:county)
      expect(market_found[:attributes][:county]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:state)
      expect(market_found[:attributes][:state]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:zip)
      expect(market_found[:attributes][:zip]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:lat)
      expect(market_found[:attributes][:lat]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:lon)
      expect(market_found[:attributes][:lon]).to be_a(String)

      expect(market_found[:attributes]).to have_key(:vendor_count)
      expect(market_found[:attributes][:vendor_count]).to eq(4)
    end
    it "SAD PATH ex2 If an invalid market id is passed in, a 404 status as well as a descriptive error message should be sent back in the response." do
      get "/api/v0/markets/123123123123"
      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end

  describe "3. GET /api/v0/markets/:id/vendors" do
    it "should return a list of all vendors in a given market" do
      market = create(:market)
      vendors = create_list(:vendor,4)
      vendors.each do |vendor|
        MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)
      end
      get "/api/v0/markets/#{market.id}/vendors"
      response_data = JSON.parse(response.body, symbolize_names: true)
      vendors_found = response_data[:data]
      

      expect(response).to be_successful
      expect(vendors_found.size).to eq(4)
      vendors_found.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)

        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_an(String)

        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)

      end
    end
    it "SAD PATH: should return a 404 error" do
      market = create(:market)
      vendors = create_list(:vendor,4)
      vendors.each do |vendor|
        MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)
      end
      get "/api/v0/markets/123123123123/vendors"
      vendors = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendors).to have_key(:errors)
      expect(vendors[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end

  describe "10. GET /api/v0/markets/search" do
    it "should return a response 200 with the market data if these datasets match: [state], [state, city], [state, city, name], [state, name], [name]" do
      market = create(:market)

      get "/api/v0/markets/search?state=#{market.state}"
      response_data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_data.first[:attributes][:name]).to eq(market.name)
      expect(response.status).to eq(200)
      
      get "/api/v0/markets/search?state=#{market.state}&city=#{market.city}"
      response_data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_data.first[:attributes][:name]).to eq(market.name)
      expect(response.status).to eq(200)
      
      get "/api/v0/markets/search?state=#{market.state}&city=#{market.city}&name=#{market.name}"
      response_data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_data.first[:attributes][:name]).to eq(market.name)
      expect(response.status).to eq(200)

      get "/api/v0/markets/search?state=#{market.state}&name=#{market.name}"
      response_data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_data.first[:attributes][:name]).to eq(market.name)
      expect(response.status).to eq(200)

      get "/api/v0/markets/search?name=#{market.name}"
      response_data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_data.first[:attributes][:name]).to eq(market.name)
      expect(response.status).to eq(200)
    end

    it "SAD PATH 10 ex2 The following combination of parameters can NOT be sent in at any time: [city], [city, name].  If an invalid set of parameters are sent in, a proper error message should be sent back, along with a 422 status code." do
      market = create(:market)
      get "/api/v0/markets/search?city=#{market.city}"
      response_data = JSON.parse(response.body, symbolize_names: true)
      
      expect(response_data[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      expect(response.status).to eq(422)
      
      get "/api/v0/markets/search?city=#{market.city}&name=#{market.name}"
      response_data = JSON.parse(response.body, symbolize_names: true)
      expect(response_data[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      expect(response.status).to eq(422)
    end
  end

  describe "11. GET /api/v0/markets/:id/nearest_atms" do
    it "should return a list of nearest ATMs from the Market address" do
      market = Market.create!(name: "Orchard Farmers Market", street: "14535 Delaware St", city: "Westminster", county: "Adams", state: "Colorado", zip: 80023, lat: 39.842285, lon: -105.043716)
      get "/api/v0/markets/#{market.id}/nearest_atms"
      response_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response_data[:results].first[:poi]).to have_key(:name)
      expect(response_data[:results].first[:poi][:name]).to be_a(String)

      expect(response_data[:results].first[:poi]).to have_key(:categories)
      expect(response_data[:results].first[:poi][:categories]).to be_an(Array)
      
      expect(response_data[:results].first[:address]).to have_key(:streetName)
      expect(response_data[:results].first[:address][:streetName]).to be_a(String)
    end
    it "SAD PATH 404 error" do
      get "/api/v0/markets/123123123123/nearest_atms"
      response_data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response_data).to have_key(:errors)
      expect(response_data[:errors].first[:detail]).to include("Couldn't find Market with 'id'=123123123123")
    end
  end
end