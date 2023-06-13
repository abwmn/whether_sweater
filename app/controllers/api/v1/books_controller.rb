class Api::V1::BooksController < ApplicationController
  def search
    forecast = ForecastRetriever.new(params[:location]).condensed_forecast
    books = BookRetriever.new(params[:location]).get_books
    booklist = Booklist.new(forecast, books, params[:quantity])
    render json: BookSerializer.new(booklist)
  end
end