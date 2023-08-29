# app/facades/markets_facade.rb
class MarketsFacade
  def initialize(markets)
    @markets = markets
  end

  def formatted_data
    return self.array_format if @markets.count > 1
    self.single_format
  end

  def array_format
    @markets.map do |market|
      {
        id: market.id.to_s,
        type: 'market',
        attributes: {
          name: market.name,
          street: market.street,
          city: market.city,
          county: market.county,
          state: market.state,
          zip: market.zip,
          lat: market.lat,
          lon: market.lon,
          vendor_count: market.vendors.count
        }
      }
    end
  end

  def single_format
    market = @markets[0]
    {
      id: market.id.to_s,
      type: 'market',
      attributes: {
        name: market.name,
        street: market.street,
        city: market.city,
        county: market.county,
        state: market.state,
        zip: market.zip,
        lat: market.lat,
        lon: market.lon,
        vendor_count: market.vendors.count
      }
    }
  end
end
