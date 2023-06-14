class BookService
  def self.get_books(location)
    response = Faraday.get('https://openlibrary.org/search.json') do |req|
      req.params['title'] = location
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
