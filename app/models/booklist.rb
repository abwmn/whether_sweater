class Booklist
  def initialize(forecast, books)
    @forecast = forecast
    @books = books
  end

  def id
    nil
  end

  def destination
    forecast.location[:name]
  end

  def forecast
    {
      summary: books[:current][:condition][:text],
      temperature: "#{books[:current][:temp_f]} F"
    }
  end

  def total_books_found

  end

  def books

  end
end
