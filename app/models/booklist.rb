class Booklist
  def initialize(forecast, books)
    @forecast = forecast
    @books = books
  end

  def id
    nil
  end

  def destination
    @forecast['destination']
  end

  def forecast
    @forecast['forecast']
  end

  def total_books_found

  end

  def books

  end
end
