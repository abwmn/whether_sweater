class BookRetriever
  def initialize(params)
    @params = params
  end

  def get_books
    response = Faraday.get('https://openlibrary.org/search.json') do |req|
      req.params['title'] = @params[:location]
      req.params['quantity'] = @params[:quantity]
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
