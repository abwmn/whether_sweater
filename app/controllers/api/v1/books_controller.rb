class Api::V1::BooksController < ApplicationController
  def search
    forecast = ForecastRetriever.new(params[:location]).call
    books = BookRetriever.new(params).get_books
    render json: BookSerializer.new(books)
  end
end