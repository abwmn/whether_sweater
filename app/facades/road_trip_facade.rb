class RoadTripFacade
  def self.plan_trip(params)
    travel_times = MapService.get_travel_time(params)
    return RoadTrip.new(params[:origin], params[:destination], "impossible", {}) unless travel_times

    forecast = ForecastFacade.get_forecast(params[:destination])
    eta_forecast = calculate_eta_forecast(forecast, travel_times.first)

    RoadTrip.new(params[:origin], params[:destination], travel_times.last, eta_forecast)
  end

  private

  def self.calculate_eta_forecast(forecast, travel_time_seconds)
    local_time = DateTime.parse(forecast.data[:location][:localtime])
    eta = local_time.advance(seconds: travel_time_seconds)
    hourly_forecast = extract_hourly_forecast(forecast, eta)
    define_eta_forecast(hourly_forecast)
  end

  def self.extract_hourly_forecast(forecast, eta)
    eta_date = eta.to_date.to_s
    forecast_day = forecast.data[:forecast][:forecastday].find do |day|
      day[:date] == eta_date
    end
    forecast_day[:hour][eta.hour]
  end
  
  def self.define_eta_forecast(hourly_forecast)
    {
      datetime: hourly_forecast[:time],
      temperature: hourly_forecast[:temp_f],
      condition: hourly_forecast[:condition][:text]
    }
  end
end
