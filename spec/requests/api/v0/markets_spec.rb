require "rails_helper"

RSpec.describe "Markets", type: :request do
  describe "GET /api/v0/markets" do
    it "should return a list of all markets in the database" do
      market_list = create_list(:market,4)
      get "/api/v0/markets"
      markets = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(markets.size).to eq(4)
      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(Integer)

        expect(market).to have_key(:name)
        expect(market[:name]).to be_a(String)

        expect(market).to have_key(:street)
        expect(market[:street]).to be_a(String)

        expect(market).to have_key(:city)
        expect(market[:city]).to be_a(String)

        expect(market).to have_key(:county)
        expect(market[:county]).to be_a(String)

        expect(market).to have_key(:state)
        expect(market[:state]).to be_a(String)

        expect(market).to have_key(:zip)
        expect(market[:zip]).to be_a(String)

        expect(market).to have_key(:lat)
        expect(market[:lat]).to be_a(String)

        expect(market).to have_key(:lon)
        expect(market[:lon]).to be_a(String)
      end
    end
  end
end