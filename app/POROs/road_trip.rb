class RoadTrip
  attr_reader :id, :start_city, :end_city, :travel_time, :weather_at_eta

  def initialize(start_city, end_city, travel_time, eta_forecast)
    @id = nil
    @start_city = start_city
    @end_city = end_city
    @travel_time = travel_time
    @weather_at_eta = eta_forecast
  end
end
