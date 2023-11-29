# Notes and assumptions
* No editing or updating, data is immutable
* Multiple of the same IP can be inserted, since geo data can be updated in time
* No migrations needed, because we're using MongoDB
* If we receive an URL, we're going to try and resolve the IP address
* Going for simplicity and not creating encapsulating objects since most of them will look the same
* Had a problem with using jsonapi-resources gem, because it conflicted with the mongoid gem, after an hour of debugging, I changed my strategy and used something else that doesn't offer as much out of the box.
* CSRF is turned off for simplicity
* All data received from ipstacks is stored in the DB. This is not exactly best practice, but it's simple for this exercise

# Finite list of infinite improvements
- Some fields are repeated and there is a limited number of possibilities, like Countries for example. As the data grows, it would be worth storing them in separate tables.
- Write an infinite amount of tests
- Secure the endpoints
- Pagination nation
- Use jsonapi-resources gem instead of the one using right now
- Encapsulate response from ipstacks into nicer objects, and filter the data that we get

# Running MongoDB

```sh
docker run --name mongodb -d -p 27017:27017 -v $(pwd)/data:/data/db mongodb/mongodb-community-server
```

## Export and seed data
```sh
rake data:export > db/seeds.rb # to create seeds file
rake db:drop # To drop all the data
rake db:seed # To seed the data
```

# Running the server

```sh
bundle install
rails server
```

# Curl commands

```sh
# To Create
curl -i -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"address_geolocation": {"address": "8.8.8.8", "address_type":"IP"}} ' http://localhost:3000/address_geolocations.json

# To List Everything
curl -i -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/address_geolocations.json

#
curl -i -H "Accept: application/json" -H "Content-type: application/json" -X DELETE http://localhost:3000/address_geolocations/656502acb8365d5031bbbf93.json
```

# Rails routes

```
▶ rails routes
                           Prefix Verb   URI Pattern                            Controller#Action
             address_geolocations GET    /address_geolocations(.:format)        address_geolocations#index
                                  POST   /address_geolocations(.:format)        address_geolocations#create
          new_address_geolocation GET    /address_geolocations/new(.:format)    address_geolocations#new
              address_geolocation GET    /address_geolocations/:id(.:format)    address_geolocations#show
                                  DELETE /address_geolocations/:id(.:format)    address_geolocations#destroy
               rails_health_check GET    /up(.:format)                          rails/health#show
 turbo_recede_historical_location GET    /recede_historical_location(.:format)  turbo/native/navigation#recede
 turbo_resume_historical_location GET    /resume_historical_location(.:format)  turbo/native/navigation#resume
turbo_refresh_historical_location GET    /refresh_historical_location(.:format) turbo/native/navigation#refresh
```

# Build docker image
```shell
docker build -t vstoian/professional-geolocation:latest .
```

# Run docker image
```shell
docker run -p 3000:3000 -e RAILS_MASTER_KEY=<insert-key> -d vstoian/professional-geolocation:latest
docker-compose up -d # sets the mongodb also
```

# Failz

The lovely `jsonapi-resource` gem seems to not want to work for me. Part of the reason seems to be the Mongoid gem
interaction. After investing a lot of time into fixing this, I've taken the decision to use the manual rolled JSON API,
which won't be right up to the JSONAPI specs, but it would work for the purposes of this exercise.

```
▶ rails server
=> Booting Puma
=> Rails 7.1.2 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 6.4.0 (ruby 3.2.2-p53) ("The Eagle of Durango")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 79228
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
Started GET "/address-geolocations" for 127.0.0.1 at 2023-11-27 21:14:25 +0100
Processing by AddressGeolocationsController#index as API_JSON
Internal Server Error: uninitialized constant JSONAPI::ActsAsResourceController::ActiveRecord /Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/jsonapi-resources-0.10.7/lib/jsonapi/acts_as_resource_controller.rb:133:in `rescue in process_operations'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/jsonapi-resources-0.10.7/lib/jsonapi/acts_as_resource_controller.rb:131:in `process_operations'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/jsonapi-resources-0.10.7/lib/jsonapi/acts_as_resource_controller.rb:95:in `process_request'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/jsonapi-resources-0.10.7/lib/jsonapi/acts_as_resource_controller.rb:19:in `index'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal/basic_implicit_render.rb:6:in `send_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/abstract_controller/base.rb:224:in `process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal/rendering.rb:165:in `process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/abstract_controller/callbacks.rb:259:in `block in process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/callbacks.rb:110:in `run_callbacks'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/abstract_controller/callbacks.rb:258:in `process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal/rescue.rb:25:in `process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal/instrumentation.rb:74:in `block in process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/notifications.rb:206:in `block in instrument'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/notifications/instrumenter.rb:58:in `instrument'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/notifications.rb:206:in `instrument'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal/instrumentation.rb:73:in `process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal/params_wrapper.rb:261:in `process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/mongoid-8.1.4/lib/mongoid/railties/controller_runtime.rb:21:in `process_action'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/abstract_controller/base.rb:160:in `process'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionview-7.1.2/lib/action_view/rendering.rb:40:in `process'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal.rb:227:in `dispatch'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_controller/metal.rb:309:in `dispatch'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/routing/route_set.rb:49:in `dispatch'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/routing/route_set.rb:32:in `serve'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/journey/router.rb:51:in `block in serve'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/journey/router.rb:131:in `block in find_routes'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/journey/router.rb:124:in `each'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/journey/router.rb:124:in `find_routes'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/journey/router.rb:32:in `serve'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/routing/route_set.rb:882:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-3.0.8/lib/rack/tempfile_reaper.rb:20:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-3.0.8/lib/rack/etag.rb:29:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-3.0.8/lib/rack/conditional_get.rb:31:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-3.0.8/lib/rack/head.rb:15:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/http/permissions_policy.rb:36:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/http/content_security_policy.rb:33:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-session-2.0.0/lib/rack/session/abstract/id.rb:272:in `context'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-session-2.0.0/lib/rack/session/abstract/id.rb:266:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/cookies.rb:689:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/callbacks.rb:29:in `block in call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/callbacks.rb:101:in `run_callbacks'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/callbacks.rb:28:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/executor.rb:14:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/actionable_exceptions.rb:16:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/debug_exceptions.rb:29:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:132:in `call_app'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:28:in `block in call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:17:in `catch'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:17:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/show_exceptions.rb:31:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.2/lib/rails/rack/logger.rb:37:in `call_app'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.2/lib/rails/rack/logger.rb:24:in `block in call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/tagged_logging.rb:135:in `block in tagged'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/tagged_logging.rb:39:in `tagged'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/tagged_logging.rb:135:in `tagged'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/broadcast_logger.rb:240:in `method_missing'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.2/lib/rails/rack/logger.rb:24:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sprockets-rails-3.4.2/lib/sprockets/rails/quiet_assets.rb:13:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/remote_ip.rb:92:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/request_id.rb:28:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-3.0.8/lib/rack/method_override.rb:28:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-3.0.8/lib/rack/runtime.rb:24:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/cache/strategy/local_cache_middleware.rb:29:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/server_timing.rb:59:in `block in call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/server_timing.rb:24:in `collect_events'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/server_timing.rb:58:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/executor.rb:14:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/static.rb:25:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-3.0.8/lib/rack/sendfile.rb:114:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/middleware/host_authorization.rb:141:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.2/lib/rails/engine.rb:529:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/puma-6.4.0/lib/puma/configuration.rb:272:in `call'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/puma-6.4.0/lib/puma/request.rb:100:in `block in handle_request'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/puma-6.4.0/lib/puma/thread_pool.rb:378:in `with_force_shutdown'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/puma-6.4.0/lib/puma/request.rb:99:in `handle_request'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/puma-6.4.0/lib/puma/server.rb:443:in `process_client'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/puma-6.4.0/lib/puma/server.rb:241:in `block in run'
/Users/vlad/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/puma-6.4.0/lib/puma/thread_pool.rb:155:in `block in spawn_thread'
Completed 500 Internal Server Error in 3ms (Views: 0.1ms | MongoDB: 0.0ms | Allocations: 4619)
```