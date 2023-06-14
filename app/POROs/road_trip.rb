class RoadTrip
  attr_reader :id, :start_city, :end_city, :travel_time, :weather_at_eta

  def initialize(params)
    @id = nil
    @start_city = params[:start_city]
    @end_city = params[:end_city]
    @travel_time = params[:travel_time]
    @weather_at_eta = params[:eta_forecast]
  end
end
