class Api::V1::BooksController < ApplicationController
  def search(params)
    forecast = ForecastRetriever.new(params[:location]).call
    qty = params[:qty]
  end
end