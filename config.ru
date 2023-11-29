# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

ENV['IPSTACK_ACCESS_KEY'] = Rails.application.credentials.ipstack.access_key

run Rails.application
Rails.application.load_server
