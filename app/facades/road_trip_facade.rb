class RoadTripFacade
  def initialize(params)
    @origin = params[:origin]
    @destination = params[:destination]
    @travel_times = MapService.get_travel_time(params)
    if @travel_times
      @eta = calculate_eta
      @eta_forecast = calculate_eta_forecast
    end
  end

  def plan_trip
    return RoadTrip.new(impossible_params) unless @travel_times
    RoadTrip.new(valid_params)
  end

  private

  def calculate_eta
    local_time = WeatherService.local_time(@destination)
    eta = local_time.advance(seconds: @travel_times[:seconds])
  end

  def calculate_eta_forecast
    forecast = ForecastFacade.get_forecast(@destination, @eta)
    hourly_forecast = forecast.data[:forecast][:forecastday].first[:hour][@eta.hour]
    define_eta_forecast(hourly_forecast)
  end
  
  def define_eta_forecast(hourly_forecast)
    {
      datetime: hourly_forecast[:time],
      temperature: hourly_forecast[:temp_f],
      condition: hourly_forecast[:condition][:text]
    }
  end

  def valid_params
    {
      start_city: @origin,
      end_city: @destination,
      travel_time: @travel_times[:formatted],
      eta_forecast: @eta_forecast
    }
  end

  def impossible_params
    {
      start_city: @origin,
      end_city: @destination,
      travel_time: 'impossible',
      eta_forecast: {}
    }
  end
end
