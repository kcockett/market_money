class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    markets = Market.all
    facade = MarketsFacade.new(markets)
    formatted_data = { data: facade.formatted_data }
    render json: formatted_data
  end

  def show
    market = [Market.find(params[:id])]
    facade = MarketsFacade.new(market)
    formatted_data = { data: facade.formatted_data }
    render json: formatted_data
  end

  private
  
  def record_not_found
    render json: { "errors": [{"detail" => "Could not find Market with 'id'=#{params[:market_id]}"}] }, status: :not_found
  end
end