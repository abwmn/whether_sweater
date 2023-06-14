class MapService
  def self.get_coordinates(location)
    response = conn.get('geocoding/v1/address') do |req|
      req.params['location'] = location
    end
    body = JSON.parse(response.body, symbolize_names: true)
    body[:results].first[:locations].first[:latLng]
  end

  def self.get_travel_time(params)
    response = conn.get('directions/v2/route') do |req|
      req.params['from'] = params[:origin]
      req.params['to'] = params[:destination]
    end
    body = JSON.parse(response.body, symbolize_names: true)

    if body[:info][:statuscode] == 402
      return nil
    else
      return [body[:route][:time], body[:route][:formattedTime]]
    end
  end

  private

  def self.conn
    Faraday.new('http://www.mapquestapi.com') do |req|
      req.params['key'] = ENV['MAPQUEST_API_KEY']
    end
  end
end