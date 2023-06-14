require 'rails_helper'

RSpec.describe "Api::V0::Forecasts", type: :request, vcr: true do
  describe "GET /api/v0/forecasts" do
    before do
      get api_v0_forecast_path, params: { location: 'Cincinnati,OH' }
      
      expect(response).to have_http_status(200)
  
      @data = JSON.parse(response.body)['data']
      @attributes = @data['attributes']
    end

    it "returns the correct data structure" do
      expect(@data).to have_key('id')
      expect(@data['id']).to be_nil
      expect(@data).to have_key('type')
      expect(@data['type']).to eq('forecast')
      
      expect(@data).to have_key('attributes')
    end
      
    it "Checks current_weather attributes" do
      expect(@attributes).to have_key('current_weather')
      current_weather = @attributes['current_weather']
      expect(current_weather.keys).to contain_exactly('last_updated', 'temperature', 'feels_like', 'humidity', 'uvi', 'visibility', 'condition', 'icon')
    end

    it  "Checks daily_weather attributes" do
      expect(@attributes).to have_key('daily_weather')
      daily_weather = @attributes['daily_weather']
      expect(daily_weather.count).to eq(5)

      daily_weather.each do |day|
        expect(day.keys).to contain_exactly('date', 'sunrise', 'sunset', 'max_temp', 'min_temp', 'condition', 'icon')
      end
    end

    it  "Checks hourly_weather attributes" do
      expect(@attributes).to have_key('hourly_weather')
      hourly_weather = @attributes['hourly_weather']
      expect(hourly_weather.count).to eq(24)

      hourly_weather.each do |hour|
        expect(hour.keys).to contain_exactly('time', 'temperature', 'conditions', 'icon')
      end
    end
  end
end
