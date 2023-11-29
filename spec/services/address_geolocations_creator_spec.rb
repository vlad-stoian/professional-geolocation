require 'rails_helper'
require 'uri'
require 'mongoid-rspec'

RSpec.describe AddressGeolocationsCreator do
  describe '.create_address_geolocation' do
    include Mongoid::Matchers

    let(:valid_params) { { address_type: 'URL', address: 'http://example.com' } }
    let(:invalid_url_params) { { address_type: 'URL', address: 'invalid_url' } }
    let(:unresolvable_url_params) { { address_type: 'URL', address: 'http://unresolvable-url.com' } }
    let(:invalid_address_type_params) { { address_type: 'InvalidType', address: 'http://example.com' } }

    it 'creates address geolocation with valid params' do
      allow(IpGeolocationService).to receive(:fetch_geolocation_data).and_return({ "meta": "data" })

      geolocation, errors = described_class.create_address_geolocation(valid_params)

      expect(geolocation).to be_persisted
      expect(errors).to be_empty
    end

    it 'returns an error for invalid URL' do
      geolocation, errors = described_class.create_address_geolocation(invalid_url_params)
      expect(errors).to include('Address is not a valid URL')
      expect(geolocation).not_to be_persisted
    end

    it 'returns an error for unresolvable URL' do
      geolocation, errors = described_class.create_address_geolocation(unresolvable_url_params)
      expect(errors).to include('URL cannot be resolved')
      expect(geolocation).not_to be_persisted
    end

    it 'returns an error for invalid address type' do
      geolocation, errors = described_class.create_address_geolocation(invalid_address_type_params)
      expect(errors).to include('Address type invalid')
      expect(geolocation).not_to be_persisted
    end
  end
end
