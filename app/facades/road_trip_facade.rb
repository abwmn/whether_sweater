class RoadTripFacade
  def self.plan_trip(params)
    travel_times = MapService.get_travel_time(params)
    return RoadTrip.new(params[:origin], params[:destination], "impossible", {}) unless travel_times

    forecast = ForecastFacade.get_forecast(params[:destination])
    eta_forecast = get_eta_forecast(forecast, travel_times.first)

    RoadTrip.new(params[:origin], params[:destination], travel_times.last, eta_forecast)
  end

  private

  def self.get_eta_forecast(forecast, travel_time_seconds)
    local_time = DateTime.parse(forecast.data[:location][:localtime])
    eta = local_time.advance(seconds: travel_time_seconds)
    extract_eta_forecast(forecast, eta)
  end

  def self.extract_eta_forecast(forecast, eta)
    eta_date = eta.to_date.to_s

    forecast_day = forecast.data[:forecast][:forecastday].find do |day|
      day[:date] == eta_date
    end

    hourly_forecast = forecast_day[:hour][eta.hour]

    {
      datetime: hourly_forecast[:time],
      temperature: hourly_forecast[:temp_f],
      condition: hourly_forecast[:condition][:text]
    }
  end
end
