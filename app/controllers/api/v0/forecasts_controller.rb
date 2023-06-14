class Api::V0::ForecastsController < ApplicationController
  def show
    forecast = ForecastFacade.get_forecast(params[:location])
    render json: ForecastSerializer.new(forecast)
  end
end
