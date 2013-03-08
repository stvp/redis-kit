RedisKit
========

[![Build Status](https://travis-ci.org/stvp/redis-kit.png?branch=master)](https://travis-ci.org/stvp/redis-kit) (master)

[![Build Status](https://travis-ci.org/stvp/redis-kit.png?branch=develop)](https://travis-ci.org/stvp/redis-kit) (develop)

[![Dependency Status](https://gemnasium.com/stvp/redis-kit.png)](https://gemnasium.com/stvp/redis-kit)

RedisKit is an (in-progress) gem that greatly simplifies the use of Redis in
Ruby when used with any of the following:

* Rails
* Resque
* *More soon...*

It also includes some (optional) classes that support common Redis uses:

* RedisKit::Cache (`require 'redis-kit/cache') - Cache the results of code
  blocks.

Using RedisKit
--------------

Add the following to your `Gemfile`:

```ruby
gem "redis-kit"
```

And run `bundle install`. This will install the RedisKit gem as well as the
latest stable `redis` and `hiredis` gems.

Redis connections created by RedisKit automatically use [Hiredis][hiredis], the
the [fast][hiredis_bench] and reliable (and official) C client library for
Redis. In JRuby, however, RedisKit falls back to the pure-Ruby Redis client
because JRuby doesn't support C extensions like hiredis.

[hiredis]: https://github.com/pietern/hiredis-rb
[hiredis_bench]: https://gist.github.com/894026

With Rails
----------

If you're using Rails, RedisKit includes a [Rails initializer][rails_init] that
sets up a global Redis connection when your app loads. This Redis connection is
available via `$redis`.

[rails_init]: https://github.com/stvp/redis-kit/blob/master/lib/redis-kit/railtie.rb

The configuration for Redis can come from one of two places:

1. An environment variable like "REDIS_URL". Heroku add-ons like
   [RedisGreen][rg] use environment variables to supply your Redis URL.

2. A configuration file (`config/redis.yml`) containing a section for each
   environment with settings that will be passed straight to `Redis.new`:

    ```yaml
    development:
      url: <%= ENV['REDIS_URL']%>
    test:
      mock: true
    production:
      host: sprightly-lemur-251.redisgreen.net
      port: 10092
      password: foobarbazbiz
    ```

    This file will be passed through ERB, so you can include ERB tags as shown
    above under "development" to evaluate the configuration at runtime.

    You can also include "mock: true" to use a [MockRedis][mock_redis] object.
    This should only be used in development and test environments.

[rg]: http://redisgreen.net
[mock_redis]: https://github.com/causes/mock_redis

If the environment variable doesn't exist, RedisKit will use the settings from
the config file.

With Resque
-----------

If `$redis` is a different Redis connection than `Resque.redis`, RedisKit will
handle reconnecting the connection after Resque forks. If they're the same
connection, Resque will handle the connection as usual.

Extras
======

RedisKit::Cache
---------------

RedisKit::Cache is a simple caching helper that caches values in Redis with a
configurable timeout.

```ruby
require 'redis-kit'
require 'redis-kit/cache'

# Result of block is cached for 10 seconds
RedisKit::Cache.cached("my-key", 10) do
  # ...
end

# Manually expire the cached value:
RedisKit::Cache.expire("my-key")
```

The RedisKit::Cache::Helper helper module makes working with cached values in a
class easy:

```ruby
require 'redis-kit'
require 'redis-kit/cache'

class MyCachedClass
  include RedisKit::Cache::Helper

  # This method's result will be cached in Redis for 10 seconds.
  def expensive_stuff
    cached("#{self.id}", 10) do
      # ...
    end
  end

  # Manually expire cached values, if needed:
  def reset_stuff
    expire("${self.id}")
  end
end
```

(Both the `cached` method and the `expire` methods are available at the class and
instance levels.)

You can set a class-wide namespace and default timeout:

```ruby
class MyCachedClass
  include RedisKit::Cache::Helper
  cache_timeout 600 # optional, default: 60 seconds
  cache_namespace "my-cached-class" # optional, default: no namespace

  # Cached for 10 minutes
  def expensive_stuff
    cached("#{self.id}") do
      # ...
    end
  end
end
```

Keep in mind that values are stored (and returned) by Redis as strings, so you
may need to serialize / deserialize your data manually:

```ruby
value = cached("thing") do
  JSON.dump(["cool", "values"])
end
value = JSON.load(value)
```

Support
=======

RedisKit officially supports the following Rubies:

* Ruby >= 1.9.3
* JRuby >= 1.7.0 (in 1.9 mode)
* Rubinius >= 1.2.0 (in 1.9 mode)

And the following libraries:

* Rails 3.2, 4.0
* Resque >= 1.6

Development
===========

Set up and run tests with:

    make dependencies
    make test

TODO
====

* Add block support to RedisKit::Cache's cache_namespace: `cache_namespace {
  |instance_or_class| ... }`
* Add generators for common files
  * Resque initializer
  * Unicorn config (after fork hook)
* Under forking servers (Unicorn, Rainbows, Passenger), automatically
  re-establish the connection after forking.
* Under threaded servers, provide a connection pool of Redis connections.
* Under Sidekiq, provide a pool of Redis connections for your workers to use
  based on your Sidekiq settings (when Sidekiq's redis connection != your main
  connection)
* Ensure support for all servers:
    * Multi-Process, preforking: Unicorn, Rainbows, Passenger
    * Evented (suited for sinatra-synchrony): Thin, Rainbows, Zbatery
    * Threaded: Net::HTTP::Server, Threaded Mongrel, Puma, Rainbows, Zbatery, Thin[1]

