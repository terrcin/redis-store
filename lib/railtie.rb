require 'action_dispatch'
require 'rails'

class Railtie < Rails::Railtie
 railtie_name :redis_session_store

 initializer 'redis-store.load_session_store' do |app|
   require 'middleware/session/redis_store'
  end

end
