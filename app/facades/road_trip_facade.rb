class RoadTripFacade
  def self.plan_trip(params)
    forecast = ForecastFacade.get_forecast(params[:destination])

    travel_time = MapService.get_travel_time(params)
    return RoadTrip.new(params[:origin], params[:destination], "impossible", {}) unless travel_time
    
    travel_time_seconds = travel_time.first
    travel_time_formatted = travel_time.last

    local_time = DateTime.parse(forecast.data[:location][:localtime])
    eta = local_time.advance(seconds: travel_time_seconds)

    eta_date = eta.to_date.to_s
    forecast_day = forecast.data[:forecast][:forecastday].find do |day|
      day[:date] == eta_date
    end
    forecast_hour_index = eta.hour - 1
    hourly_forecast = forecast_day[:hour][forecast_hour_index]

    eta_forecast = {
      datetime: hourly_forecast[:time],
      temperature: hourly_forecast[:temp_f],
      condition: hourly_forecast[:condition][:text]
    }

    road_trip = RoadTrip.new(params[:origin], params[:destination], travel_time_formatted, eta_forecast)
  end
end