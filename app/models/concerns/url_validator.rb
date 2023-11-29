module UrlValidator
  extend ActiveSupport::Concern

  included do
    def valid_url?(str)
      uri = URI.parse(str)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end

    def self.resolve_ip_address(url)
      uri = URI.parse url
      return nil unless uri.host
      Resolv.getaddress uri.host
    rescue Resolv::ResolvError
      return nil
    end
  end
end
