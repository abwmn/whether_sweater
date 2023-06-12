class ForecastRetriever
  def initialize(location)
    @location = location
  end

  def call
    coordinates = get_coordinates
    forecast = get_forecast(coordinates)
    Forecast.new(forecast)
  end

  def condensed_forecast
    forecast = call.data
    {
      'destination' => @location,
      'forecast' => {
        'summary' => forecast[:current][:condition][:text],
        'temperature' => "#{forecast[:current][:temp_f]} F"
      }
    }
  end

  private

  def get_coordinates
    response = Faraday.get('http://www.mapquestapi.com/geocoding/v1/address') do |req|
      req.params['key'] = ENV['MAPQUEST_API_KEY']
      req.params['location'] = @location
    end
    body = JSON.parse(response.body, symbolize_names: true)
    body[:results].first[:locations].first[:latLng]
  end

  def get_forecast(coordinates)
    response = Faraday.get('https://api.weatherapi.com/v1/forecast.json') do |req|
      req.params['key'] = ENV['WEATHER_API_KEY']
      req.params['q'] = "#{coordinates[:lat]},#{coordinates[:lng]}"
      req.params['days'] = 5
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
