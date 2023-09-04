class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all), status: :ok
  end

  def show
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue
      render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{params[:id]}"), status: :not_found
    end
  end

  def search
    facade = MarketSearchFacade.new(search_params)
    if facade.valid_parameters?
      markets = facade.search_markets
      render json: MarketSerializer.new(markets), status: :ok
    else
      render json: ErrorSerializer.serialize("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."), status: :unprocessable_entity
    end
  end

  def nearest_atms
    begin
      market = Market.find(params[:id])
    rescue
      render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{params[:id]}"), status: :not_found
    end
    
    if market
      facade = MarketAtmFacade.new(market)
      if facade.fetch_nearest_atms
        render json: { data: facade.atms }, status: :ok
      else
        render json: ErrorSerializer.serialize("facade.errors, facade.status"), status: :unprocessable_entity
      end
    end
  end

  private
  
  def market_params
    params.require(:market).permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end
  
  def search_params
    params.permit(:city, :state, :name)
  end
end