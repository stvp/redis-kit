module RedisKit
  class Cache
    module Helper
      def self.included( base )
        base.extend ClassMethods
      end

      module ClassMethods
        def cache_namespace( value = nil )
          @cache_namespace = value.to_s unless value == nil
          @cache_namespace || ""
        end

        def cache_timeout( value = nil )
          @cache_timeout = value if value
          @cache_timeout || 60
        end

        def cached( key, timeout = nil, &block )
          timeout ||= cache_timeout
          RedisKit::Cache.get with_namespace( key ), timeout, &block
        end

        def expire( key )
          RedisKit::Cache.expire with_namespace( key )
        end

        protected

        def with_namespace( key )
          cache_namespace != "" ? "#{cache_namespace}:#{key}" : key
        end
      end

      def cached( key, timeout = nil, &block )
        self.class.cached( key, timeout, &block )
      end

      def expire( key )
        self.class.expire key
      end
    end
  end
end

