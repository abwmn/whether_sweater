require 'rails_helper'

RSpec.describe "Api::V1::Book-Search", type: :request do
  describe "GET /api/v1/book-search" do

    before do
      @params = { location: 'Cincinnati,OH', quantity: 5 }
      get api_v1_book_search_path, params: @params
      @response = response
      json_response = JSON.parse(@response.body)
      @data = json_response['data']
      @attributes = @data['attributes']
    end
    
    it "returns the right id and type" do
      expect(@response).to have_http_status(200)
      
      expect(@data.keys).to contain_exactly('id', 'type', 'attributes')
      expect(@data['id']).to be_nil
      expect(@data['type']).to eq('books')
      expect(@data['attributes']).to be_a(Hash)
    end

    it "returns forecast attributes" do
      expect(@data).to have_key('attributes')

      expect(@attributes).to have_key('destination')
      forecast = @attributes['forecast']
      expect(forecast.keys).to contain_exactly('summary', 'temperature')
    end

    it "returns book search attributes" do
      expect(@attributes).to have_key('total_books_found')
      expect(@attributes['total_books_found']).to be_an(Integer)

      expect(@attributes).to have_key('books')
      expect(@attributes['books']).to be_an(Array)
      expect(@attributes['books'].count).to eq(@params[:quantity])

      @attributes['books'].each do |book|
        expect(book).to be_a(Hash)
        expect(book.keys).to contain_exactly('isbn', 'title', 'publisher')
        expect(book['isbn']).to be_an(Array)
        expect(book['isbn'].count).to eq(2)
        expect(book['isbn'].first).to be_a(String)
        expect(book['isbn'].last).to be_a(String)
        expect(book['isbn'].first.to_i).to be_an(Integer)
        expect(book['isbn'].last.to_i).to be_an(Integer)
        expect(book['title']).to be_a(String)
        expect(book['publisher']).to be_an(Array)
        expect(book['publisher'].first).to be_a(String)
      end
    end
  end
end
