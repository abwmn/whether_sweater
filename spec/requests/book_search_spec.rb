require 'rails_helper'

RSpec.describe "Api::V1::Book-Search", type: :request do
  describe "GET /api/v1/book-search" do

    before do
      get api_v1_book_search_path, params: { location: 'Cincinnati,OH', quantity: 5 }
      @response = response
      @json_response = JSON.parse(@response.body)
      @data = json_response['data']
    end

    it "returns the right id and type" do
      expect(@response).to have_http_status(200)
      
      expect(@data).to have_key('id')
      expect(@data['id']).to be_nil
      expect(@data).to have_key('type')
      expect(@data['type']).to eq('books')
    end

    it "returns forecast attributes" do
      expect(@data).to have_key('attributes')
      attributes = @data['attributes']

      expect(attributes).to have_key('destination')
      forecast = attributes['forecast']
      expect(forecast.keys).to contain_exactly('summary', 'temperature')
    end

    it "returns book search results" do

    end
  end
end
