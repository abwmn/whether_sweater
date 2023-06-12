class Api::V0::BooksController < ApplicationController
  def search(params)
    forecast = ForecastRetriever.new(params[:location]).call
    qty = params[:qty]
  end
end