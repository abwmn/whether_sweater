class Api::V1::BooksController < ApplicationController
  def search
    forecast = ForecastFacade.condensed_forecast(params[:location])
    books = BookService.get_books(params[:location])
    booklist = Booklist.new(forecast, books, params[:quantity])
    render json: BookSerializer.new(booklist)
  end
end