module AddressGeolocationsCreator
  extend self
  include UrlValidator

  def self.create_address_geolocation(params)
    @address_type = params[:address_type]
    @address = params[:address]

    @address_geolocation = AddressGeolocation.new

    return @address_geolocation, ["Address type invalid"] unless AddressGeolocation::ADDRESS_TYPES.include? @address_type

    @address_geolocation.address_type = @address_type
    @address_geolocation.address = @address

    ip = @address
    if @address_type == "URL"
      return @address_geolocation, ["Address is not a valid URL"] unless valid_url?(@address)
      # Resolve ip
      ip = resolve_ip_address @address
      return @address_geolocation, ["URL cannot be resolved"] if ip.nil?
    end
    @address_geolocation.ip = ip

    # Here we should encapsulate the response into our own model object.
    @address_geolocation.meta = IpGeolocationService.fetch_geolocation_data(@address_geolocation.ip)

    @address_geolocation.save

    return @address_geolocation, @address_geolocation.errors.map { |e| e.full_message }
  end
end

