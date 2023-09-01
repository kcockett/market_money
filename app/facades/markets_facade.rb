class MarketsFacade
  attr_reader :atms, :errors, :status
  def initialize(market)
    @market = market
    @atms = []
    @errors = []
    @status = :internal_server_error
  end

  def fetch_nearest_atms
    latitude = @market.lat
    longitude = @market.lon

    conn = Faraday.new(url: 'https://api.tomtom.com') do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    response = conn.get do |req|
      req.url "/search/2/categorySearch/ATM.json"
      req.params['key'] = ENV['TOMTOM_API_KEY']
      req.params['lat'] = latitude
      req.params['lon'] = longitude
      req.params['radius'] = 5000
      req.params['limit'] = 10
    end

    if response.status == 200
      @atms = JSON.parse(response.body)
      @status = :ok
      true
    elsif response.status == 404
      @errors = ["Market not found"]
      @status = :not_found
      false
    else
      @errors = ["Error fetching ATMs"]
      @status = :internal_server_error
      false
    end
  end
end
