class AddressGeolocation
  include Mongoid::Document
  include Mongoid::Timestamps
  include UrlValidator

  ADDRESS_TYPES = %w(IP URL)

  validates :address, :address_type, :ip, :meta, presence: true
  validates :address_type, inclusion: { in: ADDRESS_TYPES }
  validates :ip, :format => { :with => Resolv::AddressRegex }

  validate :validate_address_based_on_type

  field :address, type: String
  field :address_type, type: String
  field :ip, type: String

  field :meta, type: Hash

  private

  def validate_address_based_on_type
    if address_type == 'IP' and address !~ Resolv::AddressRegex
      errors.add(:base, "IP address is not in the right format")
    elsif address_type == 'URL' and not valid_url?(address)
      errors.add(:base, "URL address is not in the right format")
    end
  end
end
