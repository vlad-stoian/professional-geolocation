require 'rails_helper'

RSpec.describe AddressGeolocation, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:address_type) }
  it { is_expected.to validate_presence_of(:ip) }
  it { is_expected.to validate_presence_of(:meta) }

  it { is_expected.to validate_inclusion_of(:address_type).to_allow('IP', 'URL') }

  it do
    is_expected.to validate_format_of(:ip)
                     .to_allow('192.168.1.1')
                     .not_to_allow('invalid_ip')
  end

  it 'validates IP address format' do
    record = create(:address_geolocation)
    expect(record).to be_valid

    record = build(:address_geolocation, :invalid)
    expect(record).not_to be_valid
    expect(record.errors[:base]).to include('IP address is not in the right format')
  end

  it 'validates URL address format' do
    allow_any_instance_of(described_class).to receive(:valid_url?).and_return(true)

    record = create(:address_geolocation_with_url)
    expect(record).to be_valid

    allow_any_instance_of(described_class).to receive(:valid_url?).and_return(false)

    record = build(:address_geolocation_with_url, :invalid)
    expect(record).not_to be_valid
    expect(record.errors[:base]).to include('URL address is not in the right format')
  end
end
