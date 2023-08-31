class MarketSearchFacade
  attr_reader :errors

  def initialize(params)
    @params = params
    @errors = []
  end

  def valid_parameters?
    sorted_keys = @params.keys.sort.map(&:to_sym)
    valid_combinations.include?(sorted_keys)
  end

  def search_markets
    markets = Market.where(nil)

    markets = markets.by_state(@params[:state]) if @params[:state].present?
    markets = markets.by_city(@params[:city]) if @params[:city].present?
    markets = markets.by_name(@params[:name]) if @params[:name].present?

    markets
  end

  private

  def valid_combinations
    [
      [:state],
      [:state, :city],
      [:state, :city, :name],
      [:state, :name],
      [:name]
    ].map(&:sort)
  end
  
end
