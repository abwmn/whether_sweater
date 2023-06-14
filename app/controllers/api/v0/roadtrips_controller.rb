class Api::V0::RoadtripsController < ApplicationController
  def create
    # authenticate
    user = User.find_by(api_key: road_trip_params[:api_key])
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless user

    #plan trip
    road_trip = RoadTripFacade.new(road_trip_params).plan_trip
    render json: RoadTripSerializer.new(road_trip), status: :ok
  end

  private

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end
end