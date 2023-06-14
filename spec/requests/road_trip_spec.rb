require 'rails_helper'

RSpec.describe "Api::V0::RoadTrips", type: :request, vcr: true do
  before do
    @origin = 'Cincinatti,OH'
    @destination1 = 'Chicago,IL'
    @destination2 = 'London,UK'
  end

  describe "POST /create" do

    let(:user) { User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password') }

    let(:valid_attributes) do
      {
        origin: @origin,
        destination: @destination1,
        api_key: user.api_key
      }
    end

    let(:invalid_attributes) do
      {
        origin: @origin,
        destination: @destination1,
        api_key: 'invalid_api_key'
      }
    end

    let(:impossible_route) do
      {
        origin: @origin,
        destination: @destination2,
        api_key: user.api_key
      }
    end

    context "with valid parameters" do
      before { post '/api/v0/roadtrip', params: valid_attributes }

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a properly structured road trip" do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to be_a(Hash)
      
        data = parsed_response['data']
        expect(data).to be_a(Hash)
      
        expect(data['id']).to eq(nil)
        expect(data['type']).to eq('road_trip')
      
        attributes = data['attributes']
        expect(attributes).to be_a(Hash)
      
        expect(attributes['start_city']).to eq(@origin)
        expect(attributes['end_city']).to eq(@destination1)
        expect(attributes['travel_time']).to eq("04:22:44")
      
        weather_at_eta = attributes['weather_at_eta']
        expect(weather_at_eta).to be_a(Hash)
      
        expect(weather_at_eta['datetime']).to eq("2023-06-14 15:00")
        expect(weather_at_eta['temperature']).to eq(67.3)
        expect(weather_at_eta['condition']).to eq("Sunny")
      end
      
    end

    context "with invalid parameters" do
      before { post '/api/v0/roadtrip', params: invalid_attributes }

      it "returns an unauthorized response" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an impossible route" do
      before { post '/api/v0/roadtrip', params: impossible_route }

      it "returns an impossible route response" do
        attributes = JSON.parse(response.body)['data']['attributes']
        expect(attributes['travel_time']).to eq('impossible')
        expect(attributes['weather_at_eta']).to eq({})
      end
    end
  end
end
