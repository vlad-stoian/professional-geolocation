class IpGeolocationService
  def self.fetch_geolocation_data(ip)
    # Consider handling errors or providing default values if the API call fails
    Ipstack::API.standard(ip)
  end
end
