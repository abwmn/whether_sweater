class Api::V1::BooksController < ApplicationController
  def search
    forecast = ForecastRetriever.new(params[:location]).call
    books = BookRetriever.new(params).call
    render json: BookSerializer.new(books)
  end
end