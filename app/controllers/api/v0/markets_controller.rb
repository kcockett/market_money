class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: MarketSerializer.new(Market.all), status: :ok
  end

  def show
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue
      render_error("Couldn't find Market with 'id'=#{params[:id]}", :not_found)
    end
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

  def nearest_atms
    market = Market.find(params[:id])
    facade = MarketsFacade.new(market)

    if facade.fetch_nearest_atms
      render json: { data: facade.atms }, status: :ok
    else
      render_error(facade.errors, facade.status)
    end
  end

  private
  
  def market_params
    params.require(:market).permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end
  
  def search_params
    params.permit(:city, :state, :name)
  end

  def record_not_found
    render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{params[:id]}"), status: :not_found
  end

  def render_error(errors, status)
    render json: ErrorSerializer.serialize(errors), status: status
  end


  def render_market_not_found(id)
    render json: ErrorSerializer.market_not_found(id), status: :not_found
  end
end