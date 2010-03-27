module ActionDispatch
  module Session
    class RedisStore < AbstractStore
      def initialize(app, options = {})

        # Support old :expires option
        options[:expire_after] ||= options[:expires]

        super(app, options)

        # super process options into @default_options
        @default_options = {
          :namespace => 'rack:session',
          :redis_server => 'localhost:6379/0'
        }.merge(@default_options)

        @pool = options[:cache] || RedisFactory.create(@default_options[:redis_server])

        @mutex = Mutex.new
      end

      private
      def get_session(env, sid)
        sid ||= generate_sid
        begin
          session = @pool.get(sid) || {}
        rescue Errno::ECONNREFUSED
          session = {}
        end
        [sid, session]
      end

      def set_session(env, sid, session_data)
        options = env[ENV_SESSION_OPTIONS_KEY]
        expiry  = options[:expire_after]
        @pool.set(sid, session_data, expiry)
        return true
      rescue Errno::ECONNREFUSED
        return false
      end
    end
  end
end
