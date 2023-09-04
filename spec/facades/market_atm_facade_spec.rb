require 'rails_helper'

RSpec.describe MarketAtmFacade do
  describe '#fetch_nearest_atms' do
    it 'fetches nearest ATMs' do
      market = Market.create!(name: "Orchard Farmers Market", street: "14535 Delaware St", city: "Westminster", county: "Adams", state: "Colorado", zip: 80023, lat: 39.842285, lon: -105.043716) 
      facade = MarketAtmFacade.new(market)

      result = facade.fetch_nearest_atms

      expect(result).to be true
      expect(facade.status).to eq(:ok)
      expect(facade.atms).to be_an(Hash)
      expect(facade.errors).to be_empty
    end
  end
  
end
