class WeatherService
  def self.get_forecast(coordinates, time)
    response = Faraday.get('https://api.weatherapi.com/v1/forecast.json') do |req|
      req.params['key'] = ENV['WEATHER_API_KEY']
      req.params['q'] = "#{coordinates[:lat]},#{coordinates[:lng]}"
      req.params['days'] = time ? time / 3600 % 24 + 1 : 5 
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
