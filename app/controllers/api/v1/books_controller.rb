class Api::V1::BooksController < ApplicationController
  def search
    @forecast = ForecastRetriever.new(params[:location]).call.data
    books = BookRetriever.new(params).get_books
    booklist = Booklist.new(condensed_forecast, books)
    render json: BookSerializer.new(booklist)
  end

  private

  def condensed_forecast
    {
      'destination' => params[:location],
      'forecast' => {
        'summary' => @forecast[:current][:condition][:text],
        'temperature' => "#{@forecast[:current][:temp_f]} F"
      }
    }
  end
end