class WeatherService
  def self.get_forecast(coordinates, eta=nil)
    response = conn.get('v1/forecast.json') do |req|
      req.params['q'] = "#{coordinates[:lat]},#{coordinates[:lng]}"
      req.params['days'] = eta ? 1 : 5 
      req.params['dt'] = eta.to_date.to_s if eta
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.local_time(location)
    response = conn.get('v1/current.json') do |req|
      req.params['q'] = location
    end
    body = JSON.parse(response.body, symbolize_names: true)
    DateTime.parse(body[:location][:localtime])
  end

  def self.conn
    Faraday.new('https://api.weatherapi.com') do |req|
      req.params['key'] = ENV['WEATHER_API_KEY']
    end
  end
end
