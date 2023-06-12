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
    @books[:numFound]
  end

  def books
    @books[:docs].map do |book|
      # require 'pry'; binding.pry
      {
        "isbn" => book[:isbn],
        "title" => book[:title],
        "publisher" => book[:publisher]
      }
    end
  end
end
