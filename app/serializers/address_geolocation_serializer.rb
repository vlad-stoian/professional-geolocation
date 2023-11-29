class AddressGeolocationSerializer
  include JSONAPI::Serializer

  attributes :address, :address_type, :ip, :meta

  def self_link
    "#{base_url}/#{type.underscore}/#{id}.json"
  end
end
