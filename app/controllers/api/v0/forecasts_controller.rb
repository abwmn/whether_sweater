class Api::V0::ForecastsController < ApplicationController
  def show
    forecast = ForecastRetriever.new(params[:location]).call
    render json: ForecastSerializer.new(forecast)
  end
end
