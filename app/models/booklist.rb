class Booklist
  def initialize(forecast, books, quantity)
    @forecast = forecast
    @books = books
    @quantity = quantity.to_i
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
    @books[:numFound]
  end

  def books
    @books[:docs].first(@quantity).map do |book|
      {
        "isbn" => book[:isbn],
        "title" => book[:title],
        "publisher" => book[:publisher]
      }
    end
  end
end
