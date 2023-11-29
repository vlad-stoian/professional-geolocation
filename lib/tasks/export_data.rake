namespace :data do
  desc "Export AddressGeolocation"
  task :export => :environment do
    AddressGeolocation.all.each do |address_geolocation|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = address_geolocation
                     .serializable_hash
                     .delete_if { |key, value| excluded_keys.include?(key) }
      puts "AddressGeolocation.create(#{serialized})"
    end
  end
end
