class Api::V0::MarketsController < ApplicationController

  def index
    markets = Market.all
    facade = MarketsFacade.new(markets)
    formatted_data = { data: facade.formatted_data }
    render json: formatted_data
  end

  def show

  end
end