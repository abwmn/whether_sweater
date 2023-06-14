class ForecastFacade
  def self.get_forecast(location, time=nil)
    coordinates = MapService.get_coordinates(location)
    forecast = WeatherService.get_forecast(coordinates, time)
    Forecast.new(forecast)
  end

  def self.condensed_forecast(location)
    forecast = get_forecast(location).data
    {
      'destination' => location,
      'forecast' => {
        'summary' => forecast[:current][:condition][:text],
        'temperature' => "#{forecast[:current][:temp_f]} F"
      }
    }
  end
end