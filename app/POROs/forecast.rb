class Forecast
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    nil
  end

  def current_weather
    current = data[:current]
    {
      last_updated: current[:last_updated],
      temperature: current[:temp_f],
      feels_like: current[:feelslike_f],
      humidity: current[:humidity],
      uvi: current[:uv],
      visibility: current[:vis_miles],
      condition: current[:condition][:text],
      icon: current[:condition][:icon]
    }
  end

  def daily_weather
    data[:forecast][:forecastday].first(5).map do |daily|
      {
        date: daily[:date],
        sunrise: daily[:astro][:sunrise],
        sunset: daily[:astro][:sunset],
        max_temp: daily[:day][:maxtemp_f],
        min_temp: daily[:day][:mintemp_f],
        condition: daily[:day][:condition][:text],
        icon: daily[:day][:condition][:icon]
      }
    end
  end

  def hourly_weather
    data[:forecast][:forecastday][0][:hour].map do |hourly|
      {
        time: hourly[:time],
        temperature: hourly[:temp_f],
        conditions: hourly[:condition][:text],
        icon: hourly[:condition][:icon]
      }
    end
  end
end
