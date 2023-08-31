class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    facade = MarketSearchFacade.new(search_params)
    if facade.valid_parameters?
      markets = facade.search_markets
      render json: MarketSerializer.new(markets), status: :ok
    else
      render_error(facade.errors, :unprocessable_entity)
    end
  end

  private
  
  def record_not_found
    render json: ErrorSerializer.not_found('Market', params[:market_id]), status: :not_found
  end

  def render_error(errors, status)
    render json: ErrorSerializer.serialize(errors), status: status
  end

  def search_params
    params.permit(:city, :state, :name)
  end
end