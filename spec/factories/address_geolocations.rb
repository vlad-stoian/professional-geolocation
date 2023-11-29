FactoryBot.define do
  factory :address_geolocation do
    address_type { 'IP' }
    address { '192.168.1.1' }
    ip { '192.168.1.1' }
    meta { { "meta": "data" } }

    trait :invalid do
      address_type { 'IP' }
      address { 'invalid_ip' }
      ip { '192.168.1.1' }
      meta { { "meta": "data" } }
    end
  end

  factory :address_geolocation_with_url, class: 'AddressGeolocation' do
    address_type { 'URL' }
    address { 'http://example.com' }
    ip { '192.168.1.1' }
    meta { { "meta": "data" } }

    trait :invalid do
      address_type { 'URL' }
      address { 'invalid_url' }
      ip { '192.168.1.1' }
      meta { { "meta": "data" } }
    end
  end
end
